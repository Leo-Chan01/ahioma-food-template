import 'package:ahioma_food_template/features/reviews/data/data_sources/remote/reviews_api_service.dart';
import 'package:ahioma_food_template/features/reviews/data/models/create_review_request_model.dart';
import 'package:ahioma_food_template/features/reviews/data/models/update_review_request_model.dart';
import 'package:ahioma_food_template/features/reviews/domain/entities/create_review_request_entity.dart';
import 'package:ahioma_food_template/features/reviews/domain/entities/paginated_reviews_entity.dart';
import 'package:ahioma_food_template/features/reviews/domain/entities/review_entity.dart';
import 'package:ahioma_food_template/features/reviews/domain/entities/update_review_request_entity.dart';
import 'package:ahioma_food_template/features/reviews/domain/repository/reviews_repository.dart';

class ReviewsRepositoryImpl implements ReviewsRepository {
  ReviewsRepositoryImpl(this._apiService);

  final ReviewsApiService _apiService;

  @override
  Future<PaginatedReviewsEntity> getCustomerReviews({
    int? page,
    int? limit,
    String? status,
  }) async {
    final response = await _apiService.getCustomerReviews(
      page: page,
      limit: limit,
      status: status,
    );

    final responseModel = response.data;
    if (responseModel == null) {
      throw Exception('Failed to get customer reviews: No data in response');
    }

    return responseModel;
  }

  @override
  Future<ReviewEntity> addReview(
    String productId,
    CreateReviewRequestEntity request,
  ) async {
    final requestModel = CreateReviewRequestModel(
      rating: request.rating,
      title: request.title,
      comment: request.comment,
    );

    final response = await _apiService.addReview(productId, requestModel);
    final responseModel = response.data;

    if (responseModel == null) {
      throw Exception('Failed to add review: No data in response');
    }

    return responseModel;
  }

  @override
  Future<ReviewEntity> updateReview(
    String reviewId,
    UpdateReviewRequestEntity request,
  ) async {
    final requestModel = UpdateReviewRequestModel(
      rating: request.rating,
      title: request.title,
      comment: request.comment,
    );

    final response = await _apiService.updateReview(reviewId, requestModel);
    final responseModel = response.data;

    if (responseModel == null) {
      throw Exception('Failed to update review: No data in response');
    }

    return responseModel;
  }

  @override
  Future<void> deleteReview(String reviewId) async {
    await _apiService.deleteReview(reviewId);
  }
}
