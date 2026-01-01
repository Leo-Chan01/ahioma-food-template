import 'package:ahioma_food_template/features/orders/domain/entities/create_order_request_entity.dart';
import 'package:ahioma_food_template/features/orders/domain/entities/create_order_response_entity.dart';
import 'package:ahioma_food_template/features/orders/domain/entities/order_entity.dart';
import 'package:ahioma_food_template/features/orders/domain/entities/paginated_orders_entity.dart';
import 'package:ahioma_food_template/features/orders/domain/entities/review_entity.dart';
import 'package:ahioma_food_template/features/orders/domain/entities/track_order_entity.dart';
import 'package:ahioma_food_template/features/orders/domain/entities/validate_promo_code_entity.dart';

abstract class OrdersRepository {
  Future<List<OrderEntity>> getOngoingOrders();
  Future<List<OrderEntity>> getCompletedOrders();
  Future<OrderEntity?> getOrderById(String orderId);
  Future<void> submitReview(ReviewEntity review);

  /// Create order (Requires authentication)
  Future<CreateOrderResponseEntity> createOrder(
    CreateOrderRequestEntity request,
  );

  /// Get customer orders with pagination (Requires authentication)
  Future<PaginatedOrdersEntity> getCustomerOrders({
    String? status,
    int? page,
    int? limit,
    String? sortBy,
    String? sortOrder,
  });

  /// Track order by order number (Public)
  Future<TrackOrderEntity> getTrackOrder(String orderNumber);

  Future<ValidatePromoCodeEntity> validatePromoCode({
    required String promoCode,
    required String cartTotal,
  });
}
