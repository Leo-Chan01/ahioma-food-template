import 'package:equatable/equatable.dart';

class PaymentMethodEntity extends Equatable {
  const PaymentMethodEntity({
    required this.id,
    required this.name,
    required this.type,
    this.balance,
    this.cardNumber,
    this.iconName,
  });

  final String id;
  final String name;
  final PaymentMethodType type;
  final double? balance;
  final String? cardNumber;
  final String? iconName;

  @override
  List<Object?> get props => [id, name, type, balance, cardNumber, iconName];
}

enum PaymentMethodType {
  wallet,
  external,
  paypal,
  googlePay,
  applePay,
  creditCard,
}
