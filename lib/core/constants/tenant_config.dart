import 'package:ahioma_food_template/core/constants/app_constants.dart';

/// Centralized tenant configuration resolved at build time.
///
/// Provide the tenant domain via:
///   --dart-define=TENANT_DOMAIN=store.example.com
class TenantConfig {
  /// The customer storefront domain used to identify the tenant
  static const String tenantDomain = String.fromEnvironment(
    'TENANT_DOMAIN',
    defaultValue: 'ahiomacomputers.com',
  );

  /// Selected API base URL based on current environment
  static String get apiBaseUrl {
    if (Environment.isProduction) return AppConstants.productionUrl;
    if (Environment.isStaging) return AppConstants.stagingUrl;
    return AppConstants.baseUrl;
  }

  /// Optional header key for APIs that require explicit tenant routing.
  /// Leave empty to skip sending a tenant header.
  static const String tenantHeaderKey = String.fromEnvironment(
    'TENANT_HEADER_KEY',
    defaultValue: 'X-Tenant-Domain',
  );
}
