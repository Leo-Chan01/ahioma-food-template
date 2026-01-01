import 'package:ahioma_food_template/core/utils/type_defs.dart';
import 'package:ahioma_food_template/features/storefront/domain/entities/storefront_product_entity.dart';

abstract class WishlistRepository {
  /// Get user's wishlist (requires authentication)
  FutureEither<List<StorefrontProductEntity>> getWishlist();

  /// Add product to wishlist (requires authentication)
  FutureEither<StorefrontProductEntity> addToWishlist(String productId);

  /// Remove product from wishlist (requires authentication)
  FutureEither<void> removeFromWishlist(String productId);
}
