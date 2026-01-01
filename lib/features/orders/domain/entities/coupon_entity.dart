import 'package:equatable/equatable.dart';

class CouponEntity extends Equatable {
  const CouponEntity({
    required this.id,
    required this.code,
    required this.name,
    required this.description,
    required this.type,
    required this.value,
    required this.minimumAmount,
    required this.maximumDiscount,
    required this.usageLimit,
    required this.usageCount,
    required this.validFrom,
    required this.validUntil,
    required this.isActive,
  });

  final String? id;
  final String? code;
  final String? name;
  final String? description;
  final String? type;
  final int? value;
  final int? minimumAmount;
  final int? maximumDiscount;
  final int? usageLimit;
  final int? usageCount;
  final DateTime? validFrom;
  final DateTime? validUntil;
  final bool? isActive;

  @override
  List<Object?> get props => [
    id,
    code,
    name,
    description,
    type,
    value,
    minimumAmount,
    maximumDiscount,
    usageLimit,
    usageCount,
    validFrom,
    validUntil,
    isActive,
  ];
}
