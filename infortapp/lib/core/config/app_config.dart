/// Build-time environment configuration.
///
/// Defaults to the real production domain, so a plain `flutter build apk
/// --release` always targets infortsolutions.in without needing to remember
/// a --dart-define. Only override API_BASE_URL for one-off local/LAN testing:
///   flutter run --dart-define=API_BASE_URL=http://192.168.x.x:3000/api --dart-define=ENV=development
class AppConfig {
  AppConfig._();

  static const String environment = String.fromEnvironment(
    'ENV',
    defaultValue: 'production',
  );

  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://infortsolutions.in/api',
  );

  static bool get isProduction => environment == 'production';

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
}
