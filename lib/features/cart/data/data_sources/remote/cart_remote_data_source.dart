import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:ahioma_food_template/core/constants/app_constants.dart';
import 'package:ahioma_food_template/core/utils/price_formatter.dart';
import 'package:ahioma_food_template/features/cart/data/data_sources/remote/guest_cart_remote_data_source.dart';
import 'package:ahioma_food_template/features/cart/data/models/cart/cart_item_model.dart';
import 'package:ahioma_food_template/features/storefront/data/data_sources/remote/storefront_api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Unified remote data source for managing cart operations (both guest and authenticated)
/// Automatically switches between guest and authenticated cart based on authentication status
class CartRemoteDataSource {
  CartRemoteDataSource({
    required Dio dio,
    SharedPreferences? sharedPreferences,
  }) : _api = StorefrontApiService(dio),
       _guestCartDataSource = GuestCartRemoteDataSource(dio),
       _prefs = sharedPreferences;

  final StorefrontApiService _api;
  final GuestCartRemoteDataSource _guestCartDataSource;
  final SharedPreferences? _prefs;

  /// Check if user is authenticated (has a token)
  bool get _isAuthenticated {
    try {
      final token = _prefs?.getString(AppConstants.userTokenKey);
      return token != null && token.isNotEmpty;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[CartRemoteDataSource] Error checking authentication: $e');
      }
      return false;
    }
  }

  /// Get cart items (guest or authenticated)
  Future<List<CartItemModel>> getCartItems() async {
    try {
      if (_isAuthenticated) {
        final response = await _api.getCart();
        return _extractCartItems(response.data);
      } else {
        return await _guestCartDataSource.getCartItems();
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[CartRemoteDataSource] Error fetching cart: $e');
      }
      rethrow;
    }
  }

  /// Add product to cart (guest or authenticated)
  Future<CartItemModel> addToCart({
    required String productId,
    int quantity = 1,
    Map<String, dynamic>? variant,
  }) async {
    try {
      final body = {
        'productId': productId,
        'quantity': quantity,
        'variant': variant,
      };

      if (_isAuthenticated) {
        final response = await _api.addToCart(body);
        return _extractCartItem(response.data);
      } else {
        return await _guestCartDataSource.addToCart(
          productId: productId,
          quantity: quantity,
          variant: variant,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[CartRemoteDataSource] Error adding to cart: $e');
      }
      rethrow;
    }
  }

  /// Update cart item quantity (guest or authenticated)
  Future<CartItemModel> updateCartItem({
    required String itemId,
    required int quantity,
  }) async {
    try {
      final body = {
        'quantity': quantity,
      };

      if (_isAuthenticated) {
        final response = await _api.updateCartItem(itemId, body);
        return _extractCartItem(response.data);
      } else {
        return await _guestCartDataSource.updateCartItem(
          itemId: itemId,
          quantity: quantity,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[CartRemoteDataSource] Error updating cart item: $e');
      }
      rethrow;
    }
  }

  /// Remove item from cart (guest or authenticated)
  Future<void> removeCartItem(String itemId) async {
    try {
      if (_isAuthenticated) {
        await _api.removeCartItem(itemId);
      } else {
        await _guestCartDataSource.removeCartItem(itemId);
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[CartRemoteDataSource] Error removing cart item: $e');
      }
      rethrow;
    }
  }

  /// Clear entire cart (guest or authenticated)
  Future<void> clearCart() async {
    try {
      if (_isAuthenticated) {
        await _api.clearCart();
      } else {
        await _guestCartDataSource.clearCart();
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[CartRemoteDataSource] Error clearing cart: $e');
      }
      rethrow;
    }
  }

  /// Merge guest cart into authenticated cart
  /// This should be called when user logs in
  Future<void> mergeGuestCartIntoAuthenticatedCart() async {
    try {
      if (!_isAuthenticated) {
        if (kDebugMode) {
          debugPrint(
            '[CartRemoteDataSource] Cannot merge cart: user is not authenticated',
          );
        }
        return;
      }

      // Get guest cart items
      final guestCartItems = await _guestCartDataSource.getCartItems();

      if (guestCartItems.isEmpty) {
        if (kDebugMode) {
          debugPrint('[CartRemoteDataSource] No items in guest cart to merge');
        }
        return;
      }

      if (kDebugMode) {
        debugPrint(
          '[CartRemoteDataSource] Merging ${guestCartItems.length} items from guest cart',
        );
      }

      // Add each item from guest cart to authenticated cart
      for (final item in guestCartItems) {
        try {
          // Skip items without product or product ID
          final productId = item.product?.id;
          if (productId == null || productId.isEmpty) {
            if (kDebugMode) {
              debugPrint(
                '[CartRemoteDataSource] Skipping item ${item.id}: missing product ID',
              );
            }
            continue;
          }

          await addToCart(
            productId: productId,
            quantity: item.quantity ?? 1,
          );
        } catch (e) {
          if (kDebugMode) {
            debugPrint(
              '[CartRemoteDataSource] Error merging item ${item.id}: $e',
            );
          }
          // Continue with other items even if one fails
        }
      }

      // Clear guest cart after successful merge
      try {
        await _guestCartDataSource.clearCart();
        if (kDebugMode) {
          debugPrint('[CartRemoteDataSource] Guest cart cleared after merge');
        }
      } catch (e) {
        if (kDebugMode) {
          debugPrint('[CartRemoteDataSource] Error clearing guest cart: $e');
        }
        // Don't throw - merge was successful even if clearing failed
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[CartRemoteDataSource] Error merging cart: $e');
      }
      rethrow;
    }
  }

  /// Extract cart items from API response
  List<CartItemModel> _extractCartItems(dynamic data) {
    if (data == null) return [];

    var itemsList = <dynamic>[];

    if (data is List) {
      itemsList = data;
    } else if (data is Map) {
      // Check for data.cart.items structure first (most common)
      if (data['data'] is Map) {
        final dataMap = data['data'] as Map<String, dynamic>;
        if (dataMap['cart'] is Map && dataMap['cart']['items'] is List) {
          itemsList =
              (dataMap['cart'] as Map<String, dynamic>)['items'] as List;
        } else if (dataMap['items'] is List) {
          itemsList = dataMap['items'] as List;
        }
      } else if (data['data'] is List) {
        itemsList = data['data'] as List;
      } else if (data['items'] is List) {
        itemsList = data['items'] as List;
      } else if (data['cart'] is Map && data['cart']['items'] is List) {
        itemsList = (data['cart'] as Map<String, dynamic>)['items'] as List;
      }

      if (kDebugMode && itemsList.isEmpty) {
        debugPrint(
          '[CartRemoteDataSource] No items found in response structure: $data',
        );
      }
    }

    final cartItems = itemsList.map((json) {
      final itemJson = json as Map<String, dynamic>;
      if (kDebugMode) {
        debugPrint('[CartRemoteDataSource] Parsing cart item:');
        debugPrint('  Item ID: ${itemJson['id']}');
        if (itemJson['product'] is Map) {
          final product = itemJson['product'] as Map<String, dynamic>;
          debugPrint('  Product: ${product['name']}');
          debugPrint('  Product has images: ${product['images'] is List}');
          if (product['images'] is List) {
            final images = product['images'] as List;
            debugPrint('  Images count: ${images.length}');
            if (images.isNotEmpty) {
              debugPrint('  First image: ${images.first}');
            }
          }
        }
      }
      return CartItemModel.fromJson(itemJson);
    }).toList();

    if (kDebugMode) {
      debugPrint(
        '[CartRemoteDataSource] Extracted ${cartItems.length} cart items',
      );
      for (final item in cartItems) {
        debugPrint(
          '  - ${item.product?.name}: ${item.quantity}x ${item.price?.toNaira()}',
        );
        debugPrint('    Image URL: ${item.product?.imageUrl ?? 'NULL'}');
      }
    }

    return cartItems;
  }

  /// Extract single cart item from API response
  CartItemModel _extractCartItem(dynamic data) {
    if (data == null) {
      throw Exception('Invalid cart item data');
    }

    Map<String, dynamic> itemJson;

    if (data is Map) {
      if (data['data'] is Map) {
        itemJson = data['data'] as Map<String, dynamic>;
      } else if (data['data'] is Map && data['data']['item'] is Map) {
        itemJson =
            (data['data'] as Map<String, dynamic>)['item']
                as Map<String, dynamic>;
      } else {
        itemJson = data as Map<String, dynamic>;
      }
    } else {
      throw Exception('Invalid cart item data format');
    }

    return CartItemModel.fromJson(itemJson);
  }
}
