import 'package:ahioma_food_template/features/orders/domain/entities/coupon_entity.dart';

class CouponModel extends CouponEntity {
  const CouponModel({
    required super.id,
    required super.code,
    required super.name,
    required super.description,
    required super.type,
    required super.value,
    required super.minimumAmount,
    required super.maximumDiscount,
    required super.usageLimit,
    required super.usageCount,
    required super.validFrom,
    required super.validUntil,
    required super.isActive,
  });

  factory CouponModel.fromJson(Map<String, dynamic> json) {
    return CouponModel(
      id: json['id'] as String?,
      code: json['code'] as String?,
      name: json['name'] as String,
      description: json['description'] as String?,
      type: json['type'] as String?,
      value: json['value'] as int?,
      minimumAmount: json['minimumAmount'] as int?,
      maximumDiscount: json['maximumDiscount'] as int?,
      usageLimit: json['usageLimit'] as int?,
      usageCount: json['usageCount'] as int?,
      validFrom: DateTime.tryParse(json['validFrom'] as String? ?? ''),
      validUntil: DateTime.tryParse(json['validUntil'] as String? ?? ''),
      isActive: json['isActive'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'description': description,
      'type': type,
      'value': value,
      'minimumAmount': minimumAmount,
      'maximumDiscount': maximumDiscount,
      'usageLimit': usageLimit,
      'usageCount': usageCount,
      'validFrom': validFrom?.toIso8601String(),
      'validUntil': validUntil?.toIso8601String(),
      'isActive': isActive,
    };
  }
}
