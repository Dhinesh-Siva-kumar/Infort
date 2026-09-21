import 'package:shared_preferences/shared_preferences.dart';

/// Non-sensitive local preferences only. Tokens and other secrets never go
/// here — see [SecureTokenStorage] for that.
class AppPreferences {
  AppPreferences(this._prefs);

  final SharedPreferences _prefs;

  static const _themeModeKey = 'theme_mode';
  static const _biometricEnabledKey = 'biometric_enabled';

  /// 'light' | 'dark' | 'system'
  String get themeMode => _prefs.getString(_themeModeKey) ?? 'system';

  Future<void> setThemeMode(String mode) =>
      _prefs.setString(_themeModeKey, mode);

  bool get biometricEnabled => _prefs.getBool(_biometricEnabledKey) ?? false;

  Future<void> setBiometricEnabled(bool enabled) =>
      _prefs.setBool(_biometricEnabledKey, enabled);
}
