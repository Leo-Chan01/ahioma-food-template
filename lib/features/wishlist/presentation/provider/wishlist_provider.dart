import 'package:flutter/foundation.dart';
import 'package:ahioma_food_template/core/error/provider_error_handling_mixin.dart';
import 'package:ahioma_food_template/features/storefront/domain/entities/storefront_product_entity.dart';
import 'package:ahioma_food_template/features/wishlist/domain/repository/wishlist_repository.dart';
import 'package:ahioma_food_template/injection_container.dart';

class WishlistProvider extends ChangeNotifier with ProviderErrorHandling {
  WishlistProvider({
    WishlistRepository? repository,
  }) : _repository = repository ?? sl<WishlistRepository>();

  final WishlistRepository _repository;

  // Track product IDs that are in the wishlist
  final Set<String> _wishlistProductIds = <String>{};

  // Cache full product details
  List<StorefrontProductEntity> _wishlistProducts = [];

  /// Get all product IDs in wishlist
  Set<String> get wishlistProductIds => Set.unmodifiable(_wishlistProductIds);

  /// Get all wishlist products
  List<StorefrontProductEntity> get wishlistProducts =>
      List.unmodifiable(_wishlistProducts);

  /// Check if a product is in the wishlist
  bool isInWishlist(String productId) {
    return _wishlistProductIds.contains(productId);
  }

  /// Load wishlist from API
  Future<void> loadWishlist() async {
    setLoading(loading: true);
    await handleAsyncOperation(
      operation: _repository.getWishlist,
      onSuccess: (result) {
        result.fold(
          (failure) {
            setErrorFromFailure(failure, showSnackbar: false);
            if (kDebugMode) {
              debugPrint(
                '[WishlistProvider] Error loading wishlist: ${failure.message}',
              );
            }
          },
          (products) {
            clearError();
            _wishlistProducts = products;
            _wishlistProductIds.clear();
            _wishlistProductIds.addAll(products.map((p) => p.id));
            if (kDebugMode) {
              debugPrint(
                '[WishlistProvider] Loaded ${products.length} wishlist items',
              );
            }
            notifyListeners();
          },
        );
      },
    );
  }

  /// Add product to wishlist
  Future<void> addToWishlist(String productId) async {
    // Optimistically update UI
    if (!_wishlistProductIds.contains(productId)) {
      _wishlistProductIds.add(productId);
      notifyListeners();
    }

    await handleAsyncOperation(
      operation: () => _repository.addToWishlist(productId),
      onSuccess: (result) {
        result.fold(
          (failure) {
            // Revert optimistic update on error
            _wishlistProductIds.remove(productId);
            notifyListeners();
            setErrorFromFailure(failure);
          },
          (product) {
            clearError();
            // Ensure product is in the list
            if (!_wishlistProductIds.contains(productId)) {
              _wishlistProductIds.add(productId);
            }
            // Update product in cache if it exists
            final index = _wishlistProducts.indexWhere(
              (p) => p.id == productId,
            );
            if (index >= 0) {
              _wishlistProducts[index] = product;
            } else {
              _wishlistProducts.add(product);
            }
            if (kDebugMode) {
              debugPrint(
                '[WishlistProvider] Added product $productId to wishlist',
              );
            }
            notifyListeners();
          },
        );
      },
    );
  }

  /// Remove product from wishlist
  Future<void> removeFromWishlist(String productId) async {
    // Optimistically update UI
    final wasInWishlist = _wishlistProductIds.contains(productId);
    if (wasInWishlist) {
      _wishlistProductIds.remove(productId);
      _wishlistProducts.removeWhere((p) => p.id == productId);
      notifyListeners();
    }

    await handleAsyncOperation(
      operation: () => _repository.removeFromWishlist(productId),
      onSuccess: (result) {
        result.fold(
          (failure) {
            // Revert optimistic update on error
            if (wasInWishlist) {
              _wishlistProductIds.add(productId);
              // Note: We can't restore the product without fetching it again
              // This is acceptable since the API call should succeed
            }
            notifyListeners();
            setErrorFromFailure(failure);
          },
          (_) {
            clearError();
            if (kDebugMode) {
              debugPrint(
                '[WishlistProvider] Removed product $productId from wishlist',
              );
            }
            notifyListeners();
          },
        );
      },
    );
  }

  /// Clear wishlist (e.g., on logout)
  void clearWishlist() {
    _wishlistProductIds.clear();
    _wishlistProducts.clear();
    notifyListeners();
  }

  /// Refresh wishlist from API
  Future<void> refreshWishlist() async {
    await loadWishlist();
  }
}
