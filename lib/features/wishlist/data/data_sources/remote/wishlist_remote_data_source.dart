import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:ahioma_food_template/core/constants/app_constants.dart';
import 'package:ahioma_food_template/features/storefront/data/data_sources/remote/storefront_api_service.dart';
import 'package:ahioma_food_template/features/storefront/data/models/storefront_product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Remote data source for managing wishlist operations (requires authentication)
/// All wishlist operations require the user to be authenticated
// TODO(kingraym): SIMPLIFY THIS CLASS
class WishlistRemoteDataSource {
  WishlistRemoteDataSource({
    required Dio dio,
    SharedPreferences? sharedPreferences,
  }) : _api = StorefrontApiService(dio),
       _prefs = sharedPreferences;

  final StorefrontApiService _api;
  final SharedPreferences? _prefs;

  /// Check if user is authenticated (has a token)
  bool get isAuthenticated {
    try {
      final token = _prefs?.getString(AppConstants.userTokenKey);
      return token != null && token.isNotEmpty;
    } catch (e) {
      if (kDebugMode) {
        debugPrint(
          '[WishlistRemoteDataSource] Error checking authentication: $e',
        );
      }
      return false;
    }
  }

  /// Get user's wishlist (requires authentication)
  Future<List<StorefrontProductModel>> getWishlist() async {
    if (!isAuthenticated) {
      throw Exception('User must be authenticated to view wishlist');
    }

    try {
      final response = await _api.getWishlist();
      return _extractProducts(response.data);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[WishlistRemoteDataSource] Error fetching wishlist: $e');
      }
      rethrow;
    }
  }

  /// Add product to wishlist (requires authentication)
  Future<StorefrontProductModel> addToWishlist({
    required String productId,
  }) async {
    if (!isAuthenticated) {
      throw Exception('User must be authenticated to add to wishlist');
    }

    try {
      final body = {
        'productId': productId,
      };
      final response = await _api.addToWishlist(body);
      return _extractProduct(response.data);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[WishlistRemoteDataSource] Error adding to wishlist: $e');
      }
      rethrow;
    }
  }

  /// Remove product from wishlist (requires authentication)
  Future<void> removeFromWishlist(String productId) async {
    if (!isAuthenticated) {
      throw Exception('User must be authenticated to remove from wishlist');
    }

    try {
      await _api.removeFromWishlist(productId);
    } catch (e) {
      if (kDebugMode) {
        debugPrint(
          '[WishlistRemoteDataSource] Error removing from wishlist: $e',
        );
      }
      rethrow;
    }
  }

  /// Extract products from API response
  /// Expected structure: {"success":true,"data":{"wishlist":{"items":[...],"totalItems":1}}}
  List<StorefrontProductModel> _extractProducts(dynamic data) {
    if (data == null) return [];

    var productsList = <dynamic>[];

    if (data is List) {
      productsList = data;
    } else if (data is Map) {
      // Handle: data.data.wishlist.items (actual API structure)
      if (data['data'] is Map) {
        final dataMap = data['data'] as Map<String, dynamic>;
        if (dataMap['wishlist'] is Map) {
          final wishlistMap = dataMap['wishlist'] as Map<String, dynamic>;
          if (wishlistMap['items'] is List) {
            productsList = wishlistMap['items'] as List;
          }
        }
        // Fallback: data.data.items
        else if (dataMap['items'] is List) {
          productsList = dataMap['items'] as List;
        }
      }
      // Handle: data.items
      else if (data['items'] is List) {
        productsList = data['items'] as List;
      }
      // Handle: data.wishlist.items
      else if (data['wishlist'] is Map) {
        final wishlistMap = data['wishlist'] as Map<String, dynamic>;
        if (wishlistMap['items'] is List) {
          productsList = wishlistMap['items'] as List;
        }
      }
      // Handle: data.wishlist is List (direct array)
      else if (data['wishlist'] is List) {
        productsList = data['wishlist'] as List;
      }
    }

    final products = productsList.map((json) {
      final itemJson = json as Map<String, dynamic>;
      // Extract product from wishlist item if nested
      // Structure: {"id":"wl_...","product":{...},"addedAt":"...","updatedAt":"..."}
      if (itemJson['product'] is Map) {
        return StorefrontProductModel.fromJson(
          itemJson['product'] as Map<String, dynamic>,
        );
      }
      // If product is not nested, assume the item itself is the product
      return StorefrontProductModel.fromJson(itemJson);
    }).toList();

    if (kDebugMode) {
      debugPrint(
        '[WishlistRemoteDataSource] Extracted ${products.length} wishlist items',
      );
      if (productsList.isNotEmpty) {
        debugPrint(
          '[WishlistRemoteDataSource] First item structure: ${productsList.first}',
        );
      }
    }

    return products;
  }

  /// Extract single product from API response
  /// Expected structure: {"success":true,"data":{"wishlist":{"items":[...]}}}
  /// or for add: {"success":true,"data":{"item":{...}}}
  StorefrontProductModel _extractProduct(dynamic data) {
    if (data == null) {
      throw Exception('Invalid wishlist item data');
    }

    Map<String, dynamic> productJson;

    if (data is Map) {
      // Handle: data.data.wishlist.items[0] or data.data.item
      if (data['data'] is Map) {
        final dataMap = data['data'] as Map<String, dynamic>;

        // Check for nested wishlist structure
        if (dataMap['wishlist'] is Map) {
          final wishlistMap = dataMap['wishlist'] as Map<String, dynamic>;
          if (wishlistMap['items'] is List &&
              (wishlistMap['items'] as List).isNotEmpty) {
            final firstItem =
                (wishlistMap['items'] as List).first as Map<String, dynamic>;
            if (firstItem['product'] is Map) {
              productJson = firstItem['product'] as Map<String, dynamic>;
            } else {
              productJson = firstItem;
            }
          } else {
            productJson = dataMap;
          }
        }
        // Check for direct item
        else if (dataMap['item'] is Map) {
          final item = dataMap['item'] as Map<String, dynamic>;
          if (item['product'] is Map) {
            productJson = item['product'] as Map<String, dynamic>;
          } else {
            productJson = item;
          }
        }
        // Check if data itself is the product
        else if (dataMap['product'] is Map) {
          productJson = dataMap['product'] as Map<String, dynamic>;
        } else {
          productJson = dataMap;
        }
      }
      // Handle: data.product
      else if (data['product'] is Map) {
        productJson = data['product'] as Map<String, dynamic>;
      }
      // Handle: data is the product itself
      else {
        productJson = data as Map<String, dynamic>;
      }
    } else {
      throw Exception('Invalid wishlist item data format');
    }

    return StorefrontProductModel.fromJson(productJson);
  }
}
