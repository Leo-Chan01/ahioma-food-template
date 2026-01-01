import 'package:dio/dio.dart';
import 'package:ahioma_food_template/features/orders/data/data_sources/local/orders_local_source.dart';
import 'package:ahioma_food_template/features/orders/data/data_sources/remote/orders_api_service.dart';
import 'package:ahioma_food_template/features/orders/data/models/create_order_request_model.dart';
import 'package:ahioma_food_template/features/orders/data/models/create_order_response_model.dart';
import 'package:ahioma_food_template/features/orders/data/models/paginated_orders_model.dart';
import 'package:ahioma_food_template/features/orders/data/models/track_order_mdoel.dart';
import 'package:ahioma_food_template/features/orders/data/models/validate_promo_model.dart';
import 'package:ahioma_food_template/features/orders/domain/entities/create_order_request_entity.dart';
import 'package:ahioma_food_template/features/orders/domain/entities/create_order_response_entity.dart';
import 'package:ahioma_food_template/features/orders/domain/entities/order_entity.dart';
import 'package:ahioma_food_template/features/orders/domain/entities/paginated_orders_entity.dart';
import 'package:ahioma_food_template/features/orders/domain/entities/review_entity.dart';
import 'package:ahioma_food_template/features/orders/domain/entities/track_order_entity.dart';
import 'package:ahioma_food_template/features/orders/domain/entities/validate_promo_code_entity.dart';
import 'package:ahioma_food_template/features/orders/domain/repository/orders_repository.dart';

class OrdersRepositoryImpl implements OrdersRepository {
  OrdersRepositoryImpl(this._localDataSource, this._apiService);

  final OrdersLocalSource _localDataSource;
  final OrdersApiService _apiService;

  @override
  Future<List<OrderEntity>> getOngoingOrders() async {
    // Use getCustomerOrders API with status filter for ongoing orders
    final response = await _apiService.getCustomerOrders(
      status: 'PENDING', // or 'PROCESSING' depending on API
      page: 1,
      limit: 100,
    );

    final responseModel = response.data;
    if (responseModel == null) {
      return [];
    }

    // Convert PaginatedOrdersModel orders to OrderEntity list
    // Note: The API returns orders in a different structure, we need to map them
    return responseModel.orders;
  }

  @override
  Future<List<OrderEntity>> getCompletedOrders() async {
    // Use getCustomerOrders API with status filter for completed orders
    final response = await _apiService.getCustomerOrders(
      status: 'COMPLETED', // or 'DELIVERED' depending on API
      page: 1,
      limit: 100,
    );

    final responseModel = response.data;
    if (responseModel == null) {
      return [];
    }

    // Convert PaginatedOrdersModel orders to OrderEntity list
    return responseModel.orders;
  }

  @override
  Future<OrderEntity?> getOrderById(String orderId) async {
    return _localDataSource.getOrderById(orderId);
  }

  @override
  Future<void> submitReview(ReviewEntity review) async {
    return _localDataSource.submitReview(
      review.orderId,
      review.rating,
      review.comment,
    );
  }

  @override
  Future<CreateOrderResponseEntity> createOrder(
    CreateOrderRequestEntity request,
  ) async {
    final requestModel = CreateOrderRequestModel(
      shippingAddressId: request.shippingAddressId,
      branchId: request.branchId,
      couponCode: request.couponCode,
      paymentMethod: request.paymentMethod,
      notes: request.notes,
      taxAmount: request.taxAmount,
      shippingAmount: request.shippingAmount,
    );

    final httpResponse = await _apiService.createOrder(requestModel);

    // Parse the response manually since API returns: {"success": true, "data": {"order": {...}}}
    final responseData = httpResponse.data;
    if (responseData == null) {
      throw Exception('Failed to create order: No data in response');
    }

    // Response should be: {"success": true, "data": {"order": {...}}}
    if (responseData is! Map<String, dynamic>) {
      throw Exception(
        'Failed to create order: Invalid response type. '
        'Expected Map, got: ${responseData.runtimeType}',
      );
    }

    // Extract data field from response
    if (!responseData.containsKey('data')) {
      throw Exception(
        'Failed to create order: Missing "data" field in response. '
        'Response: $responseData',
      );
    }

    final data = responseData['data'];
    if (data is! Map<String, dynamic>) {
      throw Exception(
        'Failed to create order: Invalid data structure. '
        'Expected Map, got: ${data.runtimeType}',
      );
    }

    // Extract order from nested structure: data.order
    if (!data.containsKey('order')) {
      throw Exception(
        'Failed to create order: Order not found in response data. '
        'Response data: $data',
      );
    }

    final orderData = data['order'];
    if (orderData is! Map<String, dynamic>) {
      throw Exception(
        'Failed to create order: Invalid order data type. '
        'Expected Map, got: ${orderData.runtimeType}',
      );
    }

    try {
      final responseModel = CreateOrderResponseModel.fromJson(orderData);
      return responseModel;
    } catch (e) {
      throw Exception(
        'Failed to parse order from response: $e. '
        'Order data: $orderData',
      );
    }
  }

  @override
  Future<PaginatedOrdersEntity> getCustomerOrders({
    String? status,
    int? page,
    int? limit,
    String? sortBy,
    String? sortOrder,
  }) async {
    final response = await _apiService.getCustomerOrders(
      status: status,
      page: page,
      limit: limit,
      sortBy: sortBy,
      sortOrder: sortOrder,
    );

    final responseModel = response.data;

    if (responseModel == null) {
      throw Exception('Failed to get orders: No data in response');
    }

    return PaginatedOrdersModel(
      orders: responseModel.orders,
      pagination: responseModel.pagination,
    );
  }

  @override
  Future<TrackOrderEntity> getTrackOrder(String orderNumber) async {
    try {
      final response = await _apiService.getTrackOrder(orderNumber);
      final responseModel = response.data;

      if (responseModel == null) {
        throw Exception('Failed to track order: No data in response');
      }

      return TrackOrderModel(
        id: responseModel.id,
        orderNumber: responseModel.orderNumber,
        status: responseModel.status,
        paymentStatus: responseModel.paymentStatus,
      );
    } on DioException catch (e) {
      // Re-throw DioException so the UI can handle it with proper error messages
      throw e;
    } catch (e) {
      // Wrap other exceptions
      throw Exception('Failed to track order: $e');
    }
  }

  @override
  Future<ValidatePromoCodeEntity> validatePromoCode({
    required String promoCode,
    required String cartTotal,
  }) async {
    // Convert cartTotal string to integer (in smallest currency unit, e.g., kobo for NGN)
    final cartTotalInt = int.tryParse(cartTotal) ?? 0;
    final body = {'promoCode': promoCode, 'cartTotal': cartTotalInt};

    final response = await _apiService.validatePromoCode(body: body);
    final responseModel = response.data;

    if (responseModel == null) {
      throw Exception('Failed to validate promo code: No data in response');
    }

    return ValidatePromoCodeModel(
      isValid: responseModel.isValid,
      coupon: responseModel.coupon,
      discount: responseModel.discount,
    );
  }
}
