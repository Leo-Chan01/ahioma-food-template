import 'package:ahioma_food_template/features/checkout/domain/entities/payment_method_entity.dart';

class PaymentMethodModel extends PaymentMethodEntity {
  const PaymentMethodModel({
    required super.id,
    required super.name,
    required super.type,
    super.balance,
    super.cardNumber,
    super.iconName,
  });

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    return PaymentMethodModel(
      id: json['id'] as String,
      name: json['name'] as String,
      type: _parsePaymentType(json['type'] as String),
      balance: json['balance'] != null
          ? (json['balance'] as num).toDouble()
          : null,
      cardNumber: json['cardNumber'] as String?,
      iconName: json['iconName'] as String?,
    );
  }

  static PaymentMethodType _parsePaymentType(String type) {
    switch (type.toLowerCase()) {
      case 'wallet':
        return PaymentMethodType.wallet;
      case 'paypal':
        return PaymentMethodType.paypal;
      case 'googlepay':
        return PaymentMethodType.googlePay;
      case 'applepay':
        return PaymentMethodType.applePay;
      case 'creditcard':
        return PaymentMethodType.creditCard;
      default:
        return PaymentMethodType.external;
    }
  }
}
