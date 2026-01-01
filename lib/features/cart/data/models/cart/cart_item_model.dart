import 'package:ahioma_food_template/features/cart/data/models/product/product_item_model.dart';
import 'package:ahioma_food_template/features/cart/domain/entities/cart/cart_item_entity.dart';

class CartItemModel extends CartItemEntity {
  const CartItemModel({
    required super.id,
    required super.product,
    required super.quantity,
    required super.price,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    // Handle price - prioritize finalPrice, subtotal, then price, then calculate
    double? price;
    if (json['finalPrice'] != null) {
      price = (json['finalPrice'] as num?)?.toDouble();
    } else if (json['subtotal'] != null) {
      price = (json['subtotal'] as num?)?.toDouble();
    } else if (json['totalPrice'] != null) {
      price = (json['totalPrice'] as num?)?.toDouble();
    } else if (json['price'] != null) {
      price = (json['price'] as num?)?.toDouble();
    } else if (json['product'] is Map) {
      final product = json['product'] as Map<String, dynamic>;
      final unitPrice = (product['price'] as num?)?.toDouble();
      final quantity = json['quantity'] as int? ?? 1;
      if (unitPrice != null) {
        price = unitPrice * quantity;
      }
    }

    // Handle product - could be nested under 'product' or flattened
    Map<String, dynamic> productJson;
    if (json['product'] is Map) {
      productJson = json['product'] as Map<String, dynamic>;
    } else {
      // Product data might be flattened in the cart item
      productJson = {
        'id': json['productId'] ?? json['id'],
        'name': json['productName'] ?? json['name'],
        'description': json['description'] ?? json['productDescription'],
        'price': json['unitPrice'] ?? json['price'],
        'imageUrl': json['imageUrl'] ?? json['image'],
        'images': json['images'],
      };
    }

    final productModel = ProductItemModel.fromJson(productJson);

    return CartItemModel(
      id: json['id']?.toString() ?? json['itemId']?.toString(),
      product: productModel,
      quantity: json['quantity'] as int? ?? 1,
      price: price ?? 0.0,
    );
  }
}
