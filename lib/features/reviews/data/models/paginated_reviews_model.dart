import 'package:ahioma_food_template/features/orders/data/models/pagination_model.dart';
import 'package:ahioma_food_template/features/reviews/data/models/review_model.dart';
import 'package:ahioma_food_template/features/reviews/domain/entities/paginated_reviews_entity.dart';

class PaginatedReviewsModel extends PaginatedReviewsEntity {
  const PaginatedReviewsModel({
    required super.reviews,
    required super.pagination,
  });

  factory PaginatedReviewsModel.fromJson(Map<String, dynamic> json) {
    final reviewsList = json['reviews'] as List<dynamic>? ?? [];
    final reviews = reviewsList
        .map((e) => ReviewModel.fromJson(e as Map<String, dynamic>))
        .toList();

    final paginationJson = json['pagination'] as Map<String, dynamic>? ?? {};
    final pagination = PaginationModel.fromJson(paginationJson);

    return PaginatedReviewsModel(reviews: reviews, pagination: pagination);
  }

  Map<String, dynamic> toJson() {
    return {
      'reviews': reviews.map((e) => (e as ReviewModel).toJson()).toList(),
      'pagination': (pagination as PaginationModel).toJson(),
    };
  }
}
