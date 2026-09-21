/// Build-time environment configuration.
///
/// Pass at build/run time, e.g.:
///   flutter run --dart-define=API_BASE_URL=http://10.0.2.2:3000/api --dart-define=ENV=development
///   flutter build apk --release --dart-define=API_BASE_URL=https://api.infort.in/api --dart-define=ENV=production
class AppConfig {
  AppConfig._();

  static const String environment = String.fromEnvironment(
    'ENV',
    defaultValue: 'development',
  );

  /// Defaults to the Android emulator's loopback alias for the host machine.
  /// Override with --dart-define=API_BASE_URL=... for a real device, iOS
  /// simulator (use http://localhost:3000/api), or a deployed backend.
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:3000/api',
  );

  static bool get isProduction => environment == 'production';

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
}
