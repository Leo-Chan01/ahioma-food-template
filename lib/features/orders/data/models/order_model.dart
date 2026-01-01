import 'package:ahioma_food_template/features/orders/data/models/order_status_detail_model.dart';
import 'package:ahioma_food_template/features/orders/domain/entities/order_entity.dart';

class OrderModel extends OrderEntity {
  const OrderModel({
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

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    // Handle both old structure (direct fields) and new API structure (with items array)
    // Check if this is the new API structure with items array
    if (json.containsKey('items') && json['items'] is List) {
      // New API structure: order with items array
      final id = json['id'] as String? ?? '';
      final orderNumber = json['orderNumber'] as String?;
      final statusStr = json['status'] as String? ?? 'PENDING';

      // Map status: PENDING/PROCESSING -> ongoing, COMPLETED/DELIVERED -> completed
      final status =
          (statusStr == 'PENDING' ||
              statusStr == 'PROCESSING' ||
              statusStr == 'SHIPPED')
          ? OrderStatus.ongoing
          : OrderStatus.completed;

      // Extract first item or use defaults
      final items = json['items'] as List<dynamic>? ?? [];
      Map<String, dynamic>? firstItem;
      if (items.isNotEmpty) {
        firstItem = items[0] as Map<String, dynamic>?;
      }

      final product = firstItem?['product'] as Map<String, dynamic>?;
      // If multiple items, show "Multiple Products", otherwise show the product name
      final productName = items.length > 1
          ? 'Multiple Products (${items.length} items)'
          : (product?['name'] as String? ?? 'Unknown Product');
      final productImages = product?['images'] as List<dynamic>? ?? [];
      final productImage = productImages.isNotEmpty
          ? productImages[0] as String
          : '';

      // Extract quantity from first item (for display purposes)
      // For price, use the order's total (not item total) since we're showing order total
      final quantity =
          firstItem?['quantity'] as int? ?? (json['total'] != null ? 1 : 0);

      // Use order total, not item total - this is the correct total for the entire order
      // The order total includes subtotal + tax + shipping - discount
      // Prices are already in NGN (not kobo), so use directly
      final price = (json['total'] as num?)?.toDouble() ?? 0.0;

      // Color and size might not be in the API response, use defaults
      final color = firstItem?['color'] as String? ?? 'N/A';
      final size = firstItem?['size'] as String? ?? 'N/A';

      // Map statusHistory to statusDetails
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
        hasReview: false,
        orderNumber: orderNumber,
      );
    } else {
      // Old structure: direct fields (for backward compatibility)
      return OrderModel(
        id: json['id'] as String,
        productName: json['productName'] as String,
        productImage: json['productImage'] as String,
        color: json['color'] as String,
        size: json['size'] as String,
        quantity: json['quantity'] as int,
        price: (json['price'] as num).toDouble(),
        status: json['status'] == 'ongoing'
            ? OrderStatus.ongoing
            : OrderStatus.completed,
        currentTrackingStatus: json['currentTrackingStatus'] as String,
        statusDetails: (json['statusDetails'] as List)
            .map(
              (e) => OrderStatusDetailModel.fromJson(e as Map<String, dynamic>),
            )
            .toList(),
        hasReview: json['hasReview'] as bool? ?? false,
        orderNumber: json['orderNumber'] as String?,
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productName': productName,
      'productImage': productImage,
      'color': color,
      'size': size,
      'quantity': quantity,
      'price': price,
      'status': status == OrderStatus.ongoing ? 'ongoing' : 'completed',
      'currentTrackingStatus': currentTrackingStatus,
      'statusDetails': statusDetails
          .map((e) => (e as OrderStatusDetailModel).toJson())
          .toList(),
      'hasReview': hasReview,
    };
  }
}
