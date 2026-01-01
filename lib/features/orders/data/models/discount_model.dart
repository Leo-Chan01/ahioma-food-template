import 'package:ahioma_food_template/features/orders/domain/entities/discount_entity.dart';

class DiscountModel extends DiscountEntity {
  DiscountModel({
    required super.amount,
    required super.type,
    required super.originalTotal,
    required super.discountedTotal,
  });

  factory DiscountModel.fromJson(Map<String, dynamic> json) {
    return DiscountModel(
      amount: json['amount'] as int?,
      type: json['type'] as String?,
      originalTotal: json['originalTotal'] as int?,
      discountedTotal: json['discountedTotal'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'type': type,
      'originalTotal': originalTotal,
      'discountedTotal': discountedTotal,
    };
  }
}
