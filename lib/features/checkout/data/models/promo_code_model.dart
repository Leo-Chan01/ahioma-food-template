import 'package:ahioma_food_template/features/checkout/domain/entities/promo_code_entity.dart';

class PromoCodeModel extends PromoCodeEntity {
  const PromoCodeModel({
    required super.id,
    required super.code,
    required super.discountPercent,
    required super.description,
  });

  factory PromoCodeModel.fromJson(Map<String, dynamic> json) {
    return PromoCodeModel(
      id: json['id'] as String,
      code: json['code'] as String,
      discountPercent: json['discountPercent'] as int,
      description: json['description'] as String,
    );
  }
}
