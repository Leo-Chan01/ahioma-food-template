import 'package:ahioma_food_template/features/reviews/domain/entities/create_review_request_entity.dart';
import 'package:ahioma_food_template/features/reviews/domain/entities/paginated_reviews_entity.dart';
import 'package:ahioma_food_template/features/reviews/domain/entities/review_entity.dart';
import 'package:ahioma_food_template/features/reviews/domain/entities/update_review_request_entity.dart';

abstract class ReviewsRepository {
  /// Get customer's reviews (Requires authentication)
  Future<PaginatedReviewsEntity> getCustomerReviews({
    int? page,
    int? limit,
    String? status,
  });

  /// Add review for a product (Requires authentication)
  Future<ReviewEntity> addReview(
    String productId,
    CreateReviewRequestEntity request,
  );

  /// Update review (Requires authentication)
  Future<ReviewEntity> updateReview(
    String reviewId,
    UpdateReviewRequestEntity request,
  );

  /// Delete review (Requires authentication)
  Future<void> deleteReview(String reviewId);
}
