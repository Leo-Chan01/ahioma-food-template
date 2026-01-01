class CheckoutData {
  const CheckoutData({
    required this.shippingAddressId,
    required this.paymentMethod,
    this.couponCode,
    this.taxAmount,
    this.shippingAmount,
    this.notes,
  });

  final String shippingAddressId;
  final String paymentMethod; // 'CARD' or 'WALLET'
  final String? couponCode;
  final double? taxAmount;
  final double? shippingAmount;
  final String? notes;
}

