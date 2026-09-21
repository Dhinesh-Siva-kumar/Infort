import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../network/api_client.dart';
import '../storage/app_preferences.dart';
import '../storage/secure_token_storage.dart';
import 'session_expiry_notifier.dart';

/// Overridden in main() once SharedPreferences.getInstance() resolves.
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    'sharedPreferencesProvider must be overridden in main()',
  );
});

final appPreferencesProvider = Provider<AppPreferences>((ref) {
  return AppPreferences(ref.watch(sharedPreferencesProvider));
});

final secureTokenStorageProvider = Provider<SecureTokenStorage>((ref) {
  return SecureTokenStorage();
});

final apiClientProvider = Provider<ApiClient>((ref) {
  final sessionExpiry = ref.watch(sessionExpiryNotifierProvider);
  return ApiClient(
    tokenStorage: ref.watch(secureTokenStorageProvider),
    onSessionExpired: sessionExpiry.notify,
  );
});
