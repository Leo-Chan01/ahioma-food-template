import 'package:ahioma_food_template/features/orders/domain/entities/order_entity.dart';

/// Response entity for order creation
/// Reuses OrderEntity as the response structure should be similar
class CreateOrderResponseEntity extends OrderEntity {
  const CreateOrderResponseEntity({
    required super.id,
    required super.productName,
    required super.productImage,
    required super.color,
    required super.size,
    required super.quantity,
    required super.price,
    required super.status,
    required super.currentTrackingStatus,
    required super.statusDetails,
    super.hasReview,
    super.orderNumber,
  });
}
