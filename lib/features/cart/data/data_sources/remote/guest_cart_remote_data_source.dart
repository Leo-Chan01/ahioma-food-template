import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:ahioma_food_template/core/utils/price_formatter.dart';
import 'package:ahioma_food_template/features/cart/data/models/cart/cart_item_model.dart';
import 'package:ahioma_food_template/features/storefront/data/data_sources/remote/storefront_api_service.dart';

/// Remote data source for managing guest cart operations via API
/// Note: X-Session-ID header is automatically injected via Dio interceptor
class GuestCartRemoteDataSource {
  GuestCartRemoteDataSource(Dio dio) : _api = StorefrontApiService(dio);

  final StorefrontApiService _api;

  /// Get guest cart items
  Future<List<CartItemModel>> getCartItems() async {
    try {
      final response = await _api.getGuestCart();
      return _extractCartItems(response.data);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[GuestCartRemoteDataSource] Error fetching cart: $e');
      }
      rethrow;
    }
  }

  /// Add product to guest cart
  Future<CartItemModel> addToCart({
    required String productId,
    int quantity = 1,
    Map<String, dynamic>? variant,
  }) async {
    try {
      // Session ID is automatically added via Dio interceptor in X-Session-ID header
      final body = {
        'productId': productId,
        'quantity': quantity,
        'variant': variant,
      };

      final response = await _api.addToGuestCart(body);
      return _extractCartItem(response.data);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[GuestCartRemoteDataSource] Error adding to cart: $e');
      }
      rethrow;
    }
  }

  /// Update cart item quantity
  Future<CartItemModel> updateCartItem({
    required String itemId,
    required int quantity,
  }) async {
    try {
      final body = {'quantity': quantity};

      final response = await _api.updateGuestCartItem(itemId, body);
      return _extractCartItem(response.data);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[GuestCartRemoteDataSource] Error updating cart item: $e');
      }
      rethrow;
    }
  }

  /// Remove item from cart
  Future<void> removeCartItem(String itemId) async {
    try {
      await _api.removeGuestCartItem(itemId);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[GuestCartRemoteDataSource] Error removing cart item: $e');
      }
      rethrow;
    }
  }

  /// Clear entire cart
  Future<void> clearCart() async {
    try {
      await _api.clearGuestCart();
      // Optionally clear session after clearing cart
      // await _sessionManager.clearSession();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[GuestCartRemoteDataSource] Error clearing cart: $e');
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
          '[GuestCartRemoteDataSource] No items found in response structure: $data',
        );
      }
    }

    final cartItems = itemsList.map((json) {
      final itemJson = json as Map<String, dynamic>;
      if (kDebugMode) {
        debugPrint('[GuestCartRemoteDataSource] Parsing cart item:');
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
        '[GuestCartRemoteDataSource] Extracted ${cartItems.length} cart items',
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
