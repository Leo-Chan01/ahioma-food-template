import 'package:ahioma_food_template/features/wallet/domain/entities/payment_credentials.dart';

class PaymentCredentialsModel extends PaymentCredentials {
  const PaymentCredentialsModel({
    required super.transactionId,
    required super.reference,
    required super.authorizationUrl,
    required super.accessCode,
    required super.amount,
    required super.currency,
  });

  factory PaymentCredentialsModel.fromJson(Map<String, dynamic> json) {
    return PaymentCredentialsModel(
      transactionId: json['data']['transactionId'] as String?,
      reference: json['data']['reference'] as String?,
      authorizationUrl: json['data']['authorizationUrl'] as String?,
      accessCode: json['data']['accessCode'] as String?,
      amount: json['data']['amount'] as int?,
      currency: json['data']['currency'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transactionId': transactionId,
      'reference': reference,
      'authorizationUrl': authorizationUrl,
      'accessCode': accessCode,
    };
  }
}
