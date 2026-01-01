import 'package:equatable/equatable.dart';
import 'package:ahioma_food_template/features/orders/domain/entities/coupon_entity.dart';
import 'package:ahioma_food_template/features/orders/domain/entities/discount_entity.dart';

class ValidatePromoCodeEntity extends Equatable {
  const ValidatePromoCodeEntity({
    required this.isValid,
    required this.coupon,
    required this.discount,
  });

  final bool? isValid;
  final CouponEntity? coupon;
  final DiscountEntity? discount;

  @override
  List<Object?> get props => [isValid, coupon, discount];
}
