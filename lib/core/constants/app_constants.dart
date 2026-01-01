/// App-wide constants
class AppConstants {
  // App Info
  static const String appName = 'Xyz Computers';
  static const String appVersion = '1.0.0';
  static const String fontFamilyName = 'Urbanist';

  // API
  // static const String baseUrl = 'https://first-xi-backend-s3ml.onrender.com';
  static const String baseUrl = 'https://staging-api.ahioma.com';
  static const String stagingUrl = 'https://staging-api.ahioma.com';
  static const String productionUrl = 'https://api.ahioma.com';
  static const Duration apiTimeout = Duration(seconds: 60);

  // Storage Keys
  static const String userTokenKey = 'user_token';
  static const String themeKey = 'theme_mode';
  static const String languageKey = 'language_code';
  // Subscription storage keys
  static const String subscriptionTierKey = 'subscription_tier_id';
  static const String subscriptionRenewalDateKey = 'subscription_renewal_iso';

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Cache Duration
  static const Duration cacheValidDuration = Duration(minutes: 5);
  static const Duration oddsRefreshInterval = Duration(seconds: 10);
}

/// Environment-specific configuration
class Environment {
  static const String dev = 'development';
  static const String staging = 'staging';
  static const String prod = 'production';

  static String get current {
    const environment = String.fromEnvironment(
      'ENVIRONMENT',
      defaultValue: dev,
    );
    return environment;
  }

  static bool get isDevelopment => current == dev;
  static bool get isStaging => current == staging;
  static bool get isProduction => current == prod;
}
