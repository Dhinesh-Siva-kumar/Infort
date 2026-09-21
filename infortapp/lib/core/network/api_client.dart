import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../config/app_config.dart';
import '../errors/app_exception.dart';
import '../storage/secure_token_storage.dart';

/// Called when the refresh token itself is invalid/expired — the app must
/// drop back to the login screen and clear any cached state.
typedef OnSessionExpired = void Function();

/// Centralized HTTP client: base URL, timeouts, auth header injection,
/// single-flight access-token refresh on 401, and consistent error mapping.
/// No screen talks to Dio directly — everything goes through this + the
/// per-feature `*Api` classes built on top of it.
class ApiClient {
  ApiClient({
    required SecureTokenStorage tokenStorage,
    required OnSessionExpired onSessionExpired,
    Dio? dio,
  }) : _tokenStorage = tokenStorage,
       _onSessionExpired = onSessionExpired,
       _dio =
           dio ??
           Dio(
             BaseOptions(
               baseUrl: AppConfig.apiBaseUrl,
               connectTimeout: AppConfig.connectTimeout,
               receiveTimeout: AppConfig.receiveTimeout,
             ),
           ) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _tokenStorage.readAccessToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401 &&
              error.requestOptions.extra['retried'] != true) {
            final refreshed = await _refreshAccessToken();
            if (refreshed) {
              final retryOptions = error.requestOptions;
              retryOptions.extra['retried'] = true;
              final token = await _tokenStorage.readAccessToken();
              retryOptions.headers['Authorization'] = 'Bearer $token';
              try {
                final response = await _dio.fetch(retryOptions);
                handler.resolve(response);
                return;
              } on DioException catch (retryError) {
                handler.next(retryError);
                return;
              }
            }
            await _tokenStorage.clear();
            _onSessionExpired();
          }
          handler.next(error);
        },
      ),
    );

    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          logPrint: (obj) {
            final text = obj.toString();
            // Never log Authorization headers/tokens, even in debug.
            if (text.contains('Authorization') || text.contains('Token'))
              return;
            debugPrint(text);
          },
        ),
      );
    }
  }

  final Dio _dio;
  final SecureTokenStorage _tokenStorage;
  final OnSessionExpired _onSessionExpired;
  Completer<bool>? _refreshCompleter;

  Future<bool> _refreshAccessToken() async {
    if (_refreshCompleter != null) {
      return _refreshCompleter!.future;
    }

    final completer = Completer<bool>();
    _refreshCompleter = completer;

    try {
      final refreshToken = await _tokenStorage.readRefreshToken();
      if (refreshToken == null) {
        completer.complete(false);
        return false;
      }

      final response = await Dio(BaseOptions(baseUrl: AppConfig.apiBaseUrl))
          .post<Map<String, dynamic>>(
            '/auth/refresh',
            data: {'refreshToken': refreshToken},
          );

      final data = response.data?['data'] as Map<String, dynamic>?;
      if (data == null) {
        completer.complete(false);
        return false;
      }

      await _tokenStorage.saveTokens(
        accessToken: data['accessToken'] as String,
        refreshToken: data['refreshToken'] as String,
      );
      completer.complete(true);
      return true;
    } catch (_) {
      completer.complete(false);
      return false;
    } finally {
      _refreshCompleter = null;
    }
  }

  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? query,
  }) =>
      _send(() => _dio.get<Map<String, dynamic>>(path, queryParameters: query));

  Future<Map<String, dynamic>> post(String path, {Object? data}) =>
      _send(() => _dio.post<Map<String, dynamic>>(path, data: data));

  Future<Map<String, dynamic>> patch(String path, {Object? data}) =>
      _send(() => _dio.patch<Map<String, dynamic>>(path, data: data));

  Future<Map<String, dynamic>> delete(String path) =>
      _send(() => _dio.delete<Map<String, dynamic>>(path));

  Future<Map<String, dynamic>> _send(
    Future<Response<Map<String, dynamic>>> Function() request,
  ) async {
    try {
      final response = await request();
      return response.data ?? const {};
    } on DioException catch (error) {
      throw _mapError(error);
    } on SocketException {
      throw const NetworkException();
    }
  }

  AppException _mapError(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return const TimeoutAppException();
    }

    if (error.type == DioExceptionType.connectionError) {
      return const NetworkException();
    }

    final response = error.response;
    if (response == null) {
      return const UnknownAppException();
    }

    final body = response.data;
    final message = body is Map<String, dynamic>
        ? body['message'] as String?
        : null;
    final code = body is Map<String, dynamic> ? body['code'] as String? : null;

    switch (response.statusCode) {
      case 400:
        final errors = body is Map<String, dynamic>
            ? body['errors'] as List<dynamic>?
            : null;
        final fieldErrors = <String, String>{};
        if (errors != null) {
          for (final issue in errors) {
            if (issue is Map<String, dynamic> &&
                issue['path'] is List &&
                issue['message'] is String) {
              final path = (issue['path'] as List).join('.');
              fieldErrors[path] = issue['message'] as String;
            }
          }
        }
        return ValidationAppException(
          message ?? 'Please check your input and try again.',
          fieldErrors,
        );
      case 401:
        return UnauthorizedException(
          message ?? 'Your session has expired. Please log in again.',
        );
      case 403:
        return UnknownAppException(
          message ?? 'You are not allowed to perform this action.',
        );
      case 404:
        return NotFoundAppException(
          message ?? 'The requested item could not be found.',
        );
      case 429:
        return UnknownAppException(
          message ?? 'Too many requests. Please try again later.',
        );
      default:
        if (code == 'DATABASE_ERROR' || (response.statusCode ?? 500) >= 500) {
          return const ServerException();
        }
        return UnknownAppException(
          message ?? 'An unexpected error occurred. Please try again.',
        );
    }
  }
}
