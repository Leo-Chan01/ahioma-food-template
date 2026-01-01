import 'package:equatable/equatable.dart';

class PaymentCredentials extends Equatable {
  const PaymentCredentials({
    this.transactionId,
    this.reference,
    this.authorizationUrl,
    this.accessCode,
    this.amount,
    this.currency,
  });

  final String? transactionId;
  final String? reference;
  final String? authorizationUrl;
  final String? accessCode;
  final int? amount;
  final String? currency;

  @override
  List<Object?> get props => throw UnimplementedError();
}
