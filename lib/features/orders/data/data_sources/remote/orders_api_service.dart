import 'package:dio/dio.dart';
import 'package:ahioma_food_template/core/api/base_response.dart';
import 'package:ahioma_food_template/core/constants/app_constants.dart';
import 'package:ahioma_food_template/features/orders/data/models/create_order_request_model.dart';
import 'package:ahioma_food_template/features/orders/data/models/paginated_orders_model.dart';
import 'package:ahioma_food_template/features/orders/data/models/track_order_mdoel.dart';
import 'package:ahioma_food_template/features/orders/data/models/validate_promo_model.dart';
import 'package:retrofit/retrofit.dart';

part 'orders_api_service.g.dart';

@RestApi(baseUrl: AppConstants.productionUrl)
abstract class OrdersApiService {
  factory OrdersApiService(Dio dio) = _OrdersApiService;

  /// Create order (Requires authentication)
  /// Note: API returns nested structure: {"data": {"order": {...}}}
  @POST('/api/storefront/orders')
  Future<HttpResponse<dynamic>> createOrder(
    @Body() CreateOrderRequestModel body,
  );

  /// Get customer orders (Requires authentication)
  @GET('/api/storefront/orders')
  Future<BaseResponse<PaginatedOrdersModel>> getCustomerOrders({
    @Query('status') String? status,
    @Query('page') int? page,
    @Query('limit') int? limit,
    @Query('sortBy') String? sortBy,
    @Query('sortOrder') String? sortOrder,
  });

  /// Track order by order number (Public)
  @GET('/api/storefront/orders/track/{orderNumber}')
  Future<BaseResponse<TrackOrderModel>> getTrackOrder(
    @Path('orderNumber') String orderNumber,
  );

  @POST('/api/storefront/validate-promo-code')
  Future<BaseResponse<ValidatePromoCodeModel>> validatePromoCode({
    @Body() required Map<String, dynamic> body,
  });
}
