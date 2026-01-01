import 'package:ahioma_food_template/features/orders/domain/entities/create_order_request_entity.dart';

class CreateOrderRequestModel extends CreateOrderRequestEntity {
  const CreateOrderRequestModel({
    required super.shippingAddressId,
    super.branchId,
    super.couponCode,
    super.paymentMethod,
    super.notes,
    super.taxAmount,
    super.shippingAmount,
  });

  Map<String, dynamic> toJson() {
    return {
      'shippingAddressId': shippingAddressId,
      // branchId is not included as requested
      if (couponCode != null && couponCode!.isNotEmpty)
        'couponCode': couponCode,
      if (paymentMethod != null) 'paymentMethod': paymentMethod,
      if (notes != null && notes!.isNotEmpty) 'notes': notes,
      'taxAmount': taxAmount?.round() ?? 0,
      'shippingAmount': shippingAmount?.round() ?? 0,
    };
  }
}
