import 'package:equatable/equatable.dart';

class DiscountEntity extends Equatable {
  const DiscountEntity({
    required this.amount,
    required this.type,
    required this.originalTotal,
    required this.discountedTotal,
  });

  final int? amount;
  final String? type;
  final int? originalTotal;
  final int? discountedTotal;

  @override
  List<Object?> get props => [amount, type, originalTotal, discountedTotal];
}
