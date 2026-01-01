import 'package:ahioma_food_template/features/orders/data/models/order_model.dart';
import 'package:ahioma_food_template/features/orders/data/models/order_status_detail_model.dart';
import 'package:ahioma_food_template/features/orders/domain/entities/create_order_response_entity.dart';
import 'package:ahioma_food_template/features/orders/domain/entities/order_entity.dart';

class CreateOrderResponseModel extends CreateOrderResponseEntity {
  const CreateOrderResponseModel({
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

  factory CreateOrderResponseModel.fromJson(Map<String, dynamic> json) {
    // API returns order with items array, we need to map it to OrderEntity structure
    final id = json['id'] as String? ?? '';
    final orderNumber = json['orderNumber'] as String?;
    final statusStr = json['status'] as String? ?? 'PENDING';

    // Map status: PENDING -> ongoing, others -> completed
    final status = statusStr == 'PENDING' || statusStr == 'PROCESSING'
        ? OrderStatus.ongoing
        : OrderStatus.completed;

    // Extract first item or use defaults
    final items = json['items'] as List<dynamic>? ?? [];
    Map<String, dynamic>? firstItem;
    if (items.isNotEmpty) {
      firstItem = items[0] as Map<String, dynamic>?;
    }

    final product = firstItem?['product'] as Map<String, dynamic>?;
    final productName = product?['name'] as String? ?? 'Multiple Products';
    final productImages = product?['images'] as List<dynamic>? ?? [];
    final productImage = productImages.isNotEmpty
        ? productImages[0] as String
        : '';

    // Extract quantity and price from first item, or use order totals
    // Prices are already in NGN (not kobo), so use directly
    final quantity =
        firstItem?['quantity'] as int? ?? (json['total'] != null ? 1 : 0);
    // Use order total, not item total - this is the correct total for the entire order
    final price = (json['total'] as num?)?.toDouble() ?? 0.0;

    // Color and size might not be in the API response, use defaults
    final color = firstItem?['color'] as String? ?? 'N/A';
    final size = firstItem?['size'] as String? ?? 'N/A';

    // Map statusHistory to statusDetails
    // API returns: [{"id": "...", "status": "...", "notes": "...", "createdAt": "..."}]
    // Model expects: {title, description, date, time, isCompleted}
    final statusHistory = json['statusHistory'] as List<dynamic>? ?? [];
    final statusDetails = statusHistory.map((e) {
      final item = e as Map<String, dynamic>;
      final createdAt = item['createdAt'] as String? ?? '';
      final dateTime = createdAt.isNotEmpty
          ? DateTime.tryParse(createdAt)
          : DateTime.now();

      return OrderStatusDetailModel(
        title: item['status'] as String? ?? 'Unknown',
        description: item['notes'] as String? ?? '',
        date: dateTime != null
            ? '${dateTime.day}/${dateTime.month}/${dateTime.year}'
            : '',
        time: dateTime != null
            ? '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}'
            : '',
        isCompleted: (item['status'] as String?) != 'PENDING',
      );
    }).toList();

    // Get current tracking status from latest status history or use order status
    final currentTrackingStatus = statusHistory.isNotEmpty
        ? (statusHistory.last as Map<String, dynamic>)['status'] as String? ??
              statusStr
        : statusStr;

    return CreateOrderResponseModel(
      id: id,
      productName: productName,
      productImage: productImage,
      color: color,
      size: size,
      quantity: quantity,
      price: price,
      status: status,
      currentTrackingStatus: currentTrackingStatus,
      statusDetails: statusDetails,
      hasReview: false,
      orderNumber: orderNumber,
    );
  }

  Map<String, dynamic> toJson() {
    return OrderModel(
      id: id,
      productName: productName,
      productImage: productImage,
      color: color,
      size: size,
      quantity: quantity,
      price: price,
      status: status,
      currentTrackingStatus: currentTrackingStatus,
      statusDetails: statusDetails,
      hasReview: hasReview,
    ).toJson();
  }
}
