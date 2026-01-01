import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ahioma_food_template/core/constants/tenant_config.dart';
import 'package:ahioma_food_template/core/utils/color_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Business profile model for tenant branding.
class BusinessProfile {
  BusinessProfile({
    required this.name,
    this.id,
    this.slug,
    this.email,
    this.phone,
    this.description,
    this.domain,
    this.logoUrl,
    this.bannerUrl,
    this.businessType,
    this.primaryColorHex,
    this.secondaryColorHex,
    this.brandTemplates,
    this.settingsJson,
  });

  factory BusinessProfile.fromJson(Map<String, dynamic> json) {
    // Accept shapes: { data: { business: {...} } }, { data: {...} }, or flat
    var root = json;
    final dataNode = json['data'];
    if (dataNode is Map<String, dynamic>) {
      root = dataNode['business'] is Map<String, dynamic>
          ? dataNode['business'] as Map<String, dynamic>
          : dataNode;
    }

    final brandColors = root['brandColors'] as Map<String, dynamic>?;
    final templates = root['brandTemplates'] as Map<String, dynamic>?;

    final primaryHex =
        (brandColors?['primary'] as String?) ??
        root['primaryColor']?.toString();
    final secondaryHex =
        (brandColors?['secondary'] as String?) ??
        root['secondaryColor']?.toString();

    // Log colors for debugging
    if (kDebugMode && (primaryHex != null || secondaryHex != null)) {
      debugPrint('[TenantRemoteDataSource] Parsed brand colors:');
      if (primaryHex != null) debugPrint('  Primary: $primaryHex');
      if (secondaryHex != null) debugPrint('  Secondary: $secondaryHex');
    }

    return BusinessProfile(
      id: root['id']?.toString(),
      name: (root['name'] ?? root['businessName'] ?? 'Storefront').toString(),
      slug: root['slug']?.toString(),
      email: root['email']?.toString(),
      phone: root['phone']?.toString(),
      description: root['description']?.toString(),
      domain: root['domain']?.toString(),
      logoUrl: (root['logoUrl'] ?? root['logo'])?.toString(),
      bannerUrl: root['banner']?.toString(),
      businessType: root['businessType']?.toString(),
      primaryColorHex: primaryHex,
      secondaryColorHex: secondaryHex,
      brandTemplates: templates == null
          ? null
          : BrandTemplates(
              card: templates['card']?.toString(),
              footer: templates['footer']?.toString(),
              navbar: templates['navbar']?.toString(),
              category: templates['category']?.toString(),
            ),
      settingsJson: root['settings'] is Map<String, dynamic>
          ? root['settings'] as Map<String, dynamic>
          : null,
    );
  }

  final String name;
  final String? id;
  final String? slug;
  final String? email;
  final String? phone;
  final String? description;
  final String? domain;
  final String? logoUrl;
  final String? bannerUrl;
  final String? businessType;
  final String? primaryColorHex;
  final String? secondaryColorHex;
  final BrandTemplates? brandTemplates;
  final Map<String, dynamic>? settingsJson;

  /// Get primary color as Color object, or null if not available
  Color? get primaryColor => primaryColorHex != null
      ? ColorUtils.parseHexColor(primaryColorHex!)
      : null;

  /// Get secondary color as Color object, or null if not available
  Color? get secondaryColor => secondaryColorHex != null
      ? ColorUtils.parseHexColor(secondaryColorHex!)
      : null;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'name': name,
    'id': id,
    'slug': slug,
    'email': email,
    'phone': phone,
    'description': description,
    'domain': domain,
    'logoUrl': logoUrl,
    'banner': bannerUrl,
    'businessType': businessType,
    'primaryColor': primaryColorHex,
    'secondaryColor': secondaryColorHex,
    'brandTemplates': brandTemplates?.toJson(),
    'settings': settingsJson,
  };
}

class BrandTemplates {
  const BrandTemplates({this.card, this.footer, this.navbar, this.category});

  final String? card;
  final String? footer;
  final String? navbar;
  final String? category;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'card': card,
    'footer': footer,
    'navbar': navbar,
    'category': category,
  };
}

/// Remote data source for fetching and caching tenant-specific business profile.
class TenantRemoteDataSource extends ChangeNotifier {
  TenantRemoteDataSource({required Dio dio, required SharedPreferences prefs})
    : _dio = dio,
      _prefs = prefs;

  static const String _cacheKey = 'tenant_business_profile';

  final Dio _dio;
  final SharedPreferences _prefs;

  BusinessProfile? _profile;
  bool _initialized = false;

  BusinessProfile? get profile => _profile;
  String get appTitle => _profile?.name ?? 'Xyz Computers';
  bool get isInitialized => _initialized;

  /// Get primary brand color, or null if not available
  Color? get primaryColor => _profile?.primaryColor;

  /// Get secondary brand color, or null if not available
  Color? get secondaryColor => _profile?.secondaryColor;

  /// Initialize and attempt to fetch remote profile; fall back to cache.
  Future<void> initialize() async {
    await _loadFromCache();
    try {
      await fetchAndCacheProfile();
    } catch (_) {
      // Ignore network errors; cached profile (if any) will be used
    } finally {
      _initialized = true;
      notifyListeners();
    }
  }

  Future<void> _loadFromCache() async {
    final jsonString = _prefs.getString(_cacheKey);
    if (jsonString == null) return;
    try {
      final map = json.decode(jsonString) as Map<String, dynamic>;
      _profile = BusinessProfile.fromJson(map);
    } catch (_) {
      // ignore corrupt cache
    }
  }

  Future<void> fetchAndCacheProfile() async {
    const path = '/api/storefront/business';
    final headers = <String, dynamic>{};
    if (TenantConfig.tenantHeaderKey.isNotEmpty) {
      headers[TenantConfig.tenantHeaderKey] = TenantConfig.tenantDomain;
    }

    final response = await _dio.get<dynamic>(
      path,
      options: Options(headers: headers),
    );

    final data = response.data;
    if (data is Map<String, dynamic>) {
      final parsed = BusinessProfile.fromJson(data);
      _profile = parsed;
      await _prefs.setString(_cacheKey, json.encode(parsed.toJson()));

      // Log confirmation of colors being set
      if (kDebugMode) {
        debugPrint('[TenantRemoteDataSource] Business profile loaded:');
        debugPrint('  Name: ${parsed.name}');
        if (parsed.primaryColor != null) {
          debugPrint(
            '  Primary Color: ${parsed.primaryColorHex} -> ${parsed.primaryColor}',
          );
        }
        if (parsed.secondaryColor != null) {
          debugPrint(
            '  Secondary Color: ${parsed.secondaryColorHex} -> ${parsed.secondaryColor}',
          );
        }
      }

      notifyListeners();
    }
  }
}
