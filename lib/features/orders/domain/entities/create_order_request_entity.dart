import 'package:equatable/equatable.dart';

class CreateOrderRequestEntity extends Equatable {
  const CreateOrderRequestEntity({
    required this.shippingAddressId,
    this.branchId,
    this.couponCode,
    this.paymentMethod,
    this.notes,
    this.taxAmount,
    this.shippingAmount,
  });

  final String shippingAddressId;
  final String? branchId;
  final String? couponCode;
  final String? paymentMethod;
  final String? notes;
  final double? taxAmount;
  final double? shippingAmount;

  @override
  List<Object?> get props => [
    shippingAddressId,
    branchId,
    couponCode,
    paymentMethod,
    notes,
    taxAmount,
    shippingAmount,
  ];
}
