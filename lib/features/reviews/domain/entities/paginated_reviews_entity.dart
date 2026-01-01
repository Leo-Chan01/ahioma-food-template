import 'package:equatable/equatable.dart';
import 'package:ahioma_food_template/features/orders/domain/entities/pagination_entity.dart';
import 'package:ahioma_food_template/features/reviews/domain/entities/review_entity.dart';

class PaginatedReviewsEntity extends Equatable {
  const PaginatedReviewsEntity({
    required this.reviews,
    required this.pagination,
  });

  final List<ReviewEntity> reviews;
  final PaginationEntity pagination;

  @override
  List<Object?> get props => [reviews, pagination];
}
