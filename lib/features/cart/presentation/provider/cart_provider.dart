import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:ahioma_food_template/core/error/provider_error_handling_mixin.dart';
import 'package:ahioma_food_template/features/cart/data/models/cart/cart_item_model.dart';
import 'package:ahioma_food_template/features/cart/domain/repository/cart_respository.dart';
import 'package:ahioma_food_template/injection_container.dart';

class CartProvider extends ChangeNotifier with ProviderErrorHandling {
  final CartRespository _repository = sl<CartRespository>();

  List<CartItemModel>? _cartItems = <CartItemModel>[];
  final Map<String, Timer> _updateDebounceTimers = {};
  final Map<String, double> _lineUnitPrices = <String, double>{};

  double? _deriveUnitPrice(CartItemModel item) {
    final productUnitPrice = item.product?.price;
    if (productUnitPrice != null && productUnitPrice > 0) {
      return productUnitPrice;
    }
    final quantity = item.quantity ?? 1;
    final linePrice = item.price;
    if (linePrice != null && linePrice > 0) {
      if (quantity > 0) {
        return linePrice / quantity;
      }
      return linePrice;
    }
    return null;
  }

  double get totalPrice =>
      _cartItems?.fold<double>(0.0, (previousValue, element) {
        // Calculate line total: price * quantity
        // The price field represents unit price, so we multiply by quantity
        final quantity = element.quantity ?? 1;
        final unitPrice = element.price ?? 0.0;
        final lineTotal = unitPrice * quantity;
        return previousValue + lineTotal;
      }) ??
      0.0;
  List<CartItemModel>? get cartItems => _cartItems;

  Future<void> loadCartItems({bool showLoading = true}) async {
    await handleAsyncOperation(
      operation: _repository.getCartItems,
      showLoading: showLoading,
      onSuccess: (result) {
        result.fold(
          (failure) {
            setErrorFromFailure(failure, showSnackbar: false);
            if (kDebugMode) {
              debugPrint(
                '[CartProvider] Error loading cart: ${failure.message}',
              );
            }
          },
          (items) {
            clearError();
            final itemsList = items as List<CartItemModel>?;
            _cartItems = itemsList;
            if (kDebugMode) {
              debugPrint(
                '[CartProvider] Loaded ${itemsList?.length ?? 0} cart items',
              );
              if (itemsList != null && itemsList.isNotEmpty) {
                for (final item in itemsList) {
                  debugPrint(
                    '  - ${item.product?.name ?? 'Unknown'}: qty=${item.quantity}, price=${item.price}',
                  );
                }
              }
            }
            notifyListeners();
          },
        );
      },
    );
  }

  /// Add product to cart
  Future<void> addToCart(String productId, {int quantity = 1}) async {
    await handleAsyncOperation(
      operation: () => _repository.addToCart(productId, quantity: quantity),
      onSuccess: (result) {
        result.fold(setErrorFromFailure, (_) {
          clearError();
          // Reload cart items after adding
          loadCartItems(showLoading: false);
        });
      },
    );
  }

  /// Remove item from cart
  Future<void> removeFromCart(String itemId) async {
    await handleAsyncOperation(
      operation: () => _repository.removeFromCart(itemId),
      onSuccess: (result) {
        result.fold(setErrorFromFailure, (_) {
          clearError();
          // Optimistically remove item locally
          _cartItems = _cartItems
              ?.where((element) => element.id != itemId)
              .toList();
          _lineUnitPrices.remove(itemId);
          notifyListeners();
          // Reload cart items after removing
          loadCartItems(showLoading: false);
        });
      },
    );
  }

  /// Update cart item quantity
  Future<void> updateCartItemQuantity({
    required String itemId,
    required int quantity,
  }) async {
    await handleAsyncOperation(
      operation: () => _repository.updateCartItemQuantity(
        itemId: itemId,
        quantity: quantity,
      ),
      onSuccess: (result) {
        result.fold(setErrorFromFailure, (_) {
          clearError();
          // Reload cart items after updating
          loadCartItems(showLoading: false);
        });
      },
    );
  }

  /// Debounce cart quantity updates to avoid spamming the API
  void updateCartItemQuantityDebounced({
    required String itemId,
    required int quantity,
    Duration delay = const Duration(milliseconds: 400),
  }) {
    _applyLocalCartQuantity(itemId: itemId, quantity: quantity);

    _updateDebounceTimers[itemId]?.cancel();
    _updateDebounceTimers[itemId] = Timer(delay, () {
      _updateDebounceTimers.remove(itemId);
      unawaited(updateCartItemQuantity(itemId: itemId, quantity: quantity));
    });
  }

  void _applyLocalCartQuantity({
    required String itemId,
    required int quantity,
  }) {
    final cartItems = _cartItems;
    if (cartItems == null) return;

    final index = cartItems.indexWhere((item) => item.id == itemId);
    if (index == -1) return;

    final currentItem = cartItems[index];
    final unitPrice = _lineUnitPrices[itemId] ?? _deriveUnitPrice(currentItem);
    if (unitPrice != null) {
      _lineUnitPrices[itemId] = unitPrice;
    }

    final updatedItem = CartItemModel(
      id: currentItem.id,
      product: currentItem.product,
      quantity: quantity,
      price: currentItem.price,
    );
    cartItems[index] = updatedItem;
    notifyListeners();
  }

  /// Clear entire cart
  Future<void> clearCart() async {
    await handleAsyncOperation(
      operation: _repository.clearCart,
      onSuccess: (result) {
        result.fold(setErrorFromFailure, (_) {
          clearError();
          // Clear local cart items immediately
          _cartItems = [];
          _lineUnitPrices.clear();
          notifyListeners();
        });
      },
    );
  }

  @override
  void dispose() {
    for (final timer in _updateDebounceTimers.values) {
      timer.cancel();
    }
    _updateDebounceTimers.clear();
    _lineUnitPrices.clear();
    super.dispose();
  }
}
