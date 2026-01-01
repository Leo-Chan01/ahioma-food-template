import 'package:ahioma_food_template/core/utils/type_defs.dart';
import 'package:ahioma_food_template/features/cart/domain/entities/cart/cart_item_entity.dart';

abstract class CartRespository {
  FutureEither<void> addToCart(String productId, {int quantity = 1});
  FutureEither<void> removeFromCart(String itemId);
  FutureEither<void> clearCart();
  FutureEither<List<CartItemEntity>?> getCartItems();
  FutureEither<void> updateCartItemQuantity({
    required String itemId,
    required int quantity,
  });
}
