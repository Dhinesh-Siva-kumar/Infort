/// Base type for all handled failures in the app. UI code should catch this
/// (never raw [DioException]/[Exception]) and render [message] directly.
sealed class AppException implements Exception {
  const AppException(this.message);

  final String message;

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  const NetworkException([
    super.message =
        'No internet connection. Please check your network and try again.',
  ]);
}

class TimeoutAppException extends AppException {
  const TimeoutAppException([
    super.message = 'The request timed out. Please try again.',
  ]);
}

class ServerException extends AppException {
  const ServerException([
    super.message = 'Something went wrong on our end. Please try again later.',
  ]);
}

class UnauthorizedException extends AppException {
  const UnauthorizedException([
    super.message = 'Your session has expired. Please log in again.',
  ]);
}

class ValidationAppException extends AppException {
  const ValidationAppException(super.message, [this.fieldErrors = const {}]);

  final Map<String, String> fieldErrors;
}

class NotFoundAppException extends AppException {
  const NotFoundAppException([
    super.message = 'The requested item could not be found.',
  ]);
}

class UnknownAppException extends AppException {
  const UnknownAppException([
    super.message = 'An unexpected error occurred. Please try again.',
  ]);
}
