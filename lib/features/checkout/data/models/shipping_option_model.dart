import 'package:ahioma_food_template/features/checkout/domain/entities/shipping_option_entity.dart';

class ShippingOptionModel extends ShippingOptionEntity {
  const ShippingOptionModel({
    required super.id,
    required super.name,
    required super.price,
    required super.estimatedArrival,
    required super.iconName,
  });

  factory ShippingOptionModel.fromJson(Map<String, dynamic> json) {
    return ShippingOptionModel(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      estimatedArrival: json['estimatedArrival'] as String,
      iconName: json['iconName'] as String,
    );
  }
}
