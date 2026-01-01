class InitializePayment {
  final String orderId;
  final double amount;
  final String callbackUrl;
  final Map<String, dynamic> metadata;

  InitializePayment({
    required this.orderId,
    required this.amount,
    required this.callbackUrl,
    required this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'amount': amount,
      'callbackUrl': callbackUrl,
      'metadata': metadata,
    };
  }
}
