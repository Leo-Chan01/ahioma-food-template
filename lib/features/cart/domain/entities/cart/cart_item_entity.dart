import 'package:equatable/equatable.dart';
import 'package:ahioma_food_template/features/cart/domain/entities/product/product_item_entity.dart';

class CartItemEntity extends Equatable {
  const CartItemEntity({
    required this.id,
    required this.product,
    required this.quantity,
    required this.price,
  });
  final String? id;
  final ProductItemEntity? product;
  final int? quantity;
  final double? price;

  @override
  List<Object?> get props => [id, product, quantity, price];
}
