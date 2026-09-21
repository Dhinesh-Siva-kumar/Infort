import '../../../core/storage/secure_token_storage.dart';
import '../domain/user.dart';
import 'auth_api.dart';

class AuthRepository {
  AuthRepository(this._api, this._tokenStorage);

  final AuthApi _api;
  final SecureTokenStorage _tokenStorage;

  Future<FounderUser> login(String email, String password) async {
    final response = await _api.login(email, password);
    final data = response['data'] as Map<String, dynamic>;

    await _tokenStorage.saveTokens(
      accessToken: data['accessToken'] as String,
      refreshToken: data['refreshToken'] as String,
    );

    return FounderUser.fromJson(data['user'] as Map<String, dynamic>);
  }

  Future<bool> hasStoredSession() async {
    final token = await _tokenStorage.readAccessToken();
    return token != null;
  }

  /// Rehydrates the current user from the backend using the stored access
  /// token (refreshed transparently by ApiClient if it has expired).
  Future<FounderUser> fetchCurrentUser() async {
    final response = await _api.me();
    return FounderUser.fromJson(response['data'] as Map<String, dynamic>);
  }

  Future<void> logout() async {
    final refreshToken = await _tokenStorage.readRefreshToken();
    if (refreshToken != null) {
      try {
        await _api.logout(refreshToken);
      } catch (_) {
        // Best-effort server-side revocation; local session is cleared regardless.
      }
    }
    await _tokenStorage.clear();
  }

  Future<void> changePassword(String currentPassword, String newPassword) {
    return _api.changePassword(currentPassword, newPassword);
  }
}
