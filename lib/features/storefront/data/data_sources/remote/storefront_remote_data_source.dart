import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:ahioma_food_template/features/storefront/data/data_sources/remote/storefront_api_service.dart';
import 'package:ahioma_food_template/features/storefront/data/models/category_model.dart';
import 'package:ahioma_food_template/features/storefront/data/models/storefront_product_model.dart';

/// Remote data source for fetching data from public storefront endpoints
class StorefrontRemoteDataSource {
  StorefrontRemoteDataSource(Dio dio) : _api = StorefrontApiService(dio);

  final StorefrontApiService _api;

  /// Get all categories (public)
  Future<List<CategoryModel>> getCategories({bool activeOnly = true}) async {
    try {
      final response = await _api.getCategories(
        active: activeOnly ? 'true' : null,
      );

      return _extractCategories(response.data);
    } catch (e) {
      if (kDebugMode) {
        debugPrint(
          '[StorefrontRemoteDataSource] Error fetching categories: $e',
        );
      }
      rethrow;
    }
  }

  /// Get category by slug (public)
  Future<CategoryModel?> getCategoryBySlug(String slug) async {
    try {
      final response = await _api.getCategoryBySlug(slug);
      return _extractCategory(response.data);
    } catch (e) {
      if (kDebugMode) {
        debugPrint(
          '[StorefrontRemoteDataSource] Error fetching category by slug: $e',
        );
      }
      if (e is DioException && e.response?.statusCode == 404) {
        return null;
      }
      rethrow;
    }
  }

  /// Get products (public)
  Future<List<StorefrontProductModel>> getProducts({
    int page = 1,
    int limit = 20,
    String? category,
    String? search,
    bool? featured,
    String? sortBy,
    String? order = 'desc',
  }) async {
    try {
      final response = await _api.getProducts(
        page: page,
        limit: limit,
        category: category,
        search: search,
        featured: featured?.toString(),
        sortBy: sortBy,
        order: order,
      );

      return _extractProducts(response.data);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[StorefrontRemoteDataSource] Error fetching products: $e');
      }
      rethrow;
    }
  }

  /// Get product by slug (public)
  Future<StorefrontProductModel?> getProductBySlug(String slug) async {
    try {
      final response = await _api.getProductBySlug(slug);
      return _extractProduct(response.data);
    } catch (e) {
      if (kDebugMode) {
        debugPrint(
          '[StorefrontRemoteDataSource] Error fetching product by slug: $e',
        );
      }
      if (e is DioException && e.response?.statusCode == 404) {
        return null;
      }
      rethrow;
    }
  }

  /// Get featured products (public)
  Future<List<StorefrontProductModel>> getFeaturedProducts({
    int limit = 10,
  }) async {
    try {
      final response = await _api.getFeaturedProducts(limit: limit);
      return _extractProducts(response.data);
    } catch (e) {
      if (kDebugMode) {
        debugPrint(
          '[StorefrontRemoteDataSource] Error fetching featured products: $e',
        );
      }
      rethrow;
    }
  }

  /// Search products (public)
  Future<List<StorefrontProductModel>> searchProducts({
    required String query,
    int page = 1,
    int limit = 20,
    String? category,
  }) async {
    try {
      final response = await _api.searchProducts(
        query: query,
        page: page,
        limit: limit,
        category: category,
      );

      return _extractProducts(response.data);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[StorefrontRemoteDataSource] Error searching products: $e');
      }
      rethrow;
    }
  }

  /// Extract categories from API response
  List<CategoryModel> _extractCategories(Object? data) {
    if (data == null) return [];

    List<dynamic> categoriesList;

    if (data is List) {
      categoriesList = data;
    } else if (data is Map) {
      final map = Map<String, dynamic>.from(data);
      if (map['data'] is List) {
        categoriesList = map['data'] as List;
      } else if (map['data'] is Map) {
        final nested = Map<String, dynamic>.from(
          map['data'] as Map<Object?, Object?>,
        );
        if (nested['categories'] is List) {
          categoriesList = nested['categories'] as List;
        } else {
          if (kDebugMode) {
            debugPrint(
              '[StorefrontRemoteDataSource] Unexpected categories structure: $data',
            );
          }
          return [];
        }
      } else if (map['categories'] is List) {
        categoriesList = map['categories'] as List;
      } else {
        if (kDebugMode) {
          debugPrint(
            '[StorefrontRemoteDataSource] Unexpected categories structure: $data',
          );
        }
        return [];
      }
    } else {
      return [];
    }

    return categoriesList
        .map((json) => CategoryModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Extract single category from API response
  CategoryModel? _extractCategory(Object? data) {
    if (data == null) return null;

    Map<String, dynamic> categoryJson;

    if (data is Map) {
      final map = Map<String, dynamic>.from(data);
      if (map['data'] is Map) {
        final nested = Map<String, dynamic>.from(
          map['data'] as Map<Object?, Object?>,
        );
        if (nested['category'] is Map) {
          categoryJson = Map<String, dynamic>.from(
            nested['category'] as Map<Object?, Object?>,
          );
        } else {
          categoryJson = nested;
        }
      } else {
        categoryJson = map;
      }
    } else {
      return null;
    }

    return CategoryModel.fromJson(categoryJson);
  }

  /// Extract products from API response
  List<StorefrontProductModel> _extractProducts(Object? data) {
    if (data == null) return [];

    List<dynamic> productsList;

    if (data is List) {
      productsList = data;
    } else if (data is Map) {
      final map = Map<String, dynamic>.from(data);
      if (map['data'] is List) {
        productsList = map['data'] as List;
      } else if (map['data'] is Map) {
        final nested = Map<String, dynamic>.from(
          map['data'] as Map<Object?, Object?>,
        );
        if (nested['products'] is List) {
          productsList = nested['products'] as List;
        } else {
          if (kDebugMode) {
            debugPrint(
              '[StorefrontRemoteDataSource] Unexpected products structure: $data',
            );
          }
          return [];
        }
      } else if (map['products'] is List) {
        productsList = map['products'] as List;
      } else if (map['results'] is List) {
        productsList = map['results'] as List;
      } else {
        if (kDebugMode) {
          debugPrint(
            '[StorefrontRemoteDataSource] Unexpected products structure: $data',
          );
        }
        return [];
      }
    } else {
      return [];
    }

    return productsList
        .map(
          (json) =>
              StorefrontProductModel.fromJson(json as Map<String, dynamic>),
        )
        .toList();
  }

  /// Extract single product from API response
  StorefrontProductModel? _extractProduct(Object? data) {
    if (data == null) return null;

    Map<String, dynamic> productJson;

    if (data is Map) {
      final map = Map<String, dynamic>.from(data);
      // Check for nested structure: data.data.product
      if (map['data'] is Map) {
        final dataMap = Map<String, dynamic>.from(
          map['data'] as Map<Object?, Object?>,
        );
        // First check if product is nested inside data
        if (dataMap['product'] is Map) {
          productJson = Map<String, dynamic>.from(
            dataMap['product'] as Map<Object?, Object?>,
          );
        } else {
          // data itself might be the product
          productJson = dataMap;
        }
      } else {
        // data is directly the product
        productJson = map;
      }

      if (kDebugMode) {
        debugPrint(
          '[StorefrontRemoteDataSource] Extracted product JSON keys: ${productJson.keys}',
        );
        debugPrint(
          '[StorefrontRemoteDataSource] Product price: ${productJson['price']}',
        );
        debugPrint(
          '[StorefrontRemoteDataSource] Product name: ${productJson['name']}',
        );
      }
    } else {
      return null;
    }

    try {
      return StorefrontProductModel.fromJson(productJson);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[StorefrontRemoteDataSource] Error parsing product: $e');
        debugPrint('[StorefrontRemoteDataSource] Product JSON: $productJson');
      }
      rethrow;
    }
  }
}
