import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../core/providers/session_expiry_notifier.dart';
import '../../data/auth_api.dart';
import '../../data/auth_repository.dart';
import '../../domain/user.dart';

sealed class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthChecking extends AuthState {
  const AuthChecking();
}

class Authenticated extends AuthState {
  const Authenticated(this.user);
  final FounderUser user;
}

class Unauthenticated extends AuthState {
  const Unauthenticated({this.message});
  final String? message;
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final api = AuthApi(ref.watch(apiClientProvider));
  return AuthRepository(api, ref.watch(secureTokenStorageProvider));
});

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) {
    final controller = AuthController(ref.watch(authRepositoryProvider));
    ref.read(sessionExpiryNotifierProvider).onExpired = controller.forceLogout;
    return controller;
  },
);

class AuthController extends StateNotifier<AuthState> {
  AuthController(this._repository) : super(const AuthInitial());

  final AuthRepository _repository;

  Future<void> checkAuthStatus() async {
    state = const AuthChecking();
    final hasSession = await _repository.hasStoredSession();
    if (!hasSession) {
      state = const Unauthenticated();
      return;
    }

    try {
      final user = await _repository.fetchCurrentUser();
      state = Authenticated(user);
    } on AppException {
      state = const Unauthenticated();
    }
  }

  Future<void> login(String email, String password) async {
    state = const AuthChecking();
    try {
      final user = await _repository.login(email, password);
      state = Authenticated(user);
    } on AppException catch (e) {
      state = Unauthenticated(message: e.message);
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    state = const Unauthenticated();
  }

  /// Called by ApiClient when a refresh attempt fails (refresh token expired
  /// or revoked) — forces the user back to the login screen.
  void forceLogout() {
    state = const Unauthenticated(
      message: 'Your session has expired. Please log in again.',
    );
  }

  void updateUser(FounderUser user) {
    state = Authenticated(user);
  }
}
