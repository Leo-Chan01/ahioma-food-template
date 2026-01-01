import 'package:dio/dio.dart';
import 'package:ahioma_food_template/core/api/base_response.dart';
import 'package:ahioma_food_template/core/constants/app_constants.dart';
import 'package:ahioma_food_template/features/reviews/data/models/create_review_request_model.dart';
import 'package:ahioma_food_template/features/reviews/data/models/paginated_reviews_model.dart';
import 'package:ahioma_food_template/features/reviews/data/models/review_model.dart';
import 'package:ahioma_food_template/features/reviews/data/models/update_review_request_model.dart';
import 'package:retrofit/retrofit.dart';

part 'reviews_api_service.g.dart';

@RestApi(baseUrl: AppConstants.productionUrl)
abstract class ReviewsApiService {
  factory ReviewsApiService(Dio dio) = _ReviewsApiService;

  /// Get customer's reviews (Requires authentication)
  @GET('/api/storefront/customers/reviews')
  Future<BaseResponse<PaginatedReviewsModel>> getCustomerReviews({
    @Query('page') int? page,
    @Query('limit') int? limit,
    @Query('status') String? status,
  });

  /// Add review for a product (Requires authentication)
  @POST('/api/storefront/customers/products/{productId}/reviews')
  Future<BaseResponse<ReviewModel>> addReview(
    @Path('productId') String productId,
    @Body() CreateReviewRequestModel body,
  );

  /// Update review (Requires authentication)
  @PUT('/api/storefront/customers/reviews/{reviewId}')
  Future<BaseResponse<ReviewModel>> updateReview(
    @Path('reviewId') String reviewId,
    @Body() UpdateReviewRequestModel body,
  );

  /// Delete review (Requires authentication)
  @DELETE('/api/storefront/customers/reviews/{reviewId}')
  Future<BaseResponse<void>> deleteReview(@Path('reviewId') String reviewId);
}
