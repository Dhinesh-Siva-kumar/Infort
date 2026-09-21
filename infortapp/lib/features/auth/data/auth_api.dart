import '../../../core/network/api_client.dart';

class AuthApi {
  AuthApi(this._client);

  final ApiClient _client;

  Future<Map<String, dynamic>> login(String email, String password) {
    return _client.post(
      '/auth/login',
      data: {'email': email, 'password': password},
    );
  }

  /// Used to hydrate the current user on app start when only tokens (no user
  /// object) have survived a restart.
  Future<Map<String, dynamic>> me() {
    return _client.get('/profile');
  }

  Future<Map<String, dynamic>> refresh(String refreshToken) {
    return _client.post('/auth/refresh', data: {'refreshToken': refreshToken});
  }

  Future<void> logout(String refreshToken) {
    return _client.post('/auth/logout', data: {'refreshToken': refreshToken});
  }

  Future<void> changePassword(String currentPassword, String newPassword) {
    return _client.post(
      '/auth/change-password',
      data: {'currentPassword': currentPassword, 'newPassword': newPassword},
    );
  }
}
