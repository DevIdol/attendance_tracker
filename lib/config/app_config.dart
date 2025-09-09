class AppConfig {
  static const String flavor = String.fromEnvironment(
    'FLAVOR',
    defaultValue: '',
  );

  static const String appName = String.fromEnvironment(
    'APP_NAME',
    defaultValue: '',
  );

  static const String googleApiKey = String.fromEnvironment(
    'GOOGLE_API_KEY',
    defaultValue: '',
  );

  static const bool enableLogging = bool.fromEnvironment(
    'ENABLE_LOGGING',
    defaultValue: false,
  );

  static String get fullAppName =>
      '$appName${flavor != 'prod' ? '.$flavor' : ''}';
  static bool get isDev => flavor == 'dev';
  static bool get isStaging => flavor == 'staging';
  static bool get isProd => flavor == 'prod';
}
