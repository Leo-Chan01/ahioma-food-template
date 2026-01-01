import 'package:equatable/equatable.dart';
import 'package:ahioma_food_template/features/orders/domain/entities/order_status_detail_entity.dart';

enum OrderStatus { ongoing, completed }

class OrderEntity extends Equatable {
  const OrderEntity({
    required this.id,
    required this.productName,
    required this.productImage,
    required this.color,
    required this.size,
    required this.quantity,
    required this.price,
    required this.status,
    required this.currentTrackingStatus,
    required this.statusDetails,
    this.hasReview = false,
    this.orderNumber,
  });

  final String id;
  final String productName;
  final String productImage;
  final String color;
  final String size;
  final int quantity;
  final double price;
  final OrderStatus status;
  final String currentTrackingStatus;
  final List<OrderStatusDetailEntity> statusDetails;
  final bool hasReview;
  final String? orderNumber;

  @override
  List<Object?> get props => [
    id,
    productName,
    productImage,
    color,
    size,
    quantity,
    price,
    status,
    currentTrackingStatus,
    statusDetails,
    hasReview,
    orderNumber,
  ];
}
