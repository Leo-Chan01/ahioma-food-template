import 'package:ahioma_food_template/features/orders/data/models/coupon_model.dart';
import 'package:ahioma_food_template/features/orders/data/models/discount_model.dart';
import 'package:ahioma_food_template/features/orders/domain/entities/validate_promo_code_entity.dart';

class ValidatePromoCodeModel extends ValidatePromoCodeEntity {
  const ValidatePromoCodeModel({
    required super.isValid,
    required super.coupon,
    required super.discount,
  });

  factory ValidatePromoCodeModel.fromJson(Map<String, dynamic> json) {
    return ValidatePromoCodeModel(
      isValid: json['isValid'] as bool? ?? false,
      coupon: CouponModel.fromJson(json['coupon'] as Map<String, dynamic>),
      discount: DiscountModel.fromJson(
        json['discount'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isValid': isValid,
      'coupon': (coupon as CouponModel?)?.toJson(),
      'discount': (discount as DiscountModel?)?.toJson(),
    };
  }
}
