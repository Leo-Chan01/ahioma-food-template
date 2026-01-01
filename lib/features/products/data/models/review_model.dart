import 'package:ahioma_food_template/features/products/domain/entities/review_entity.dart';

class ReviewModel extends ReviewEntity {
  const ReviewModel({
    required super.id,
    required super.userName,
    required super.userImageUrl,
    required super.rating,
    required super.comment,
    required super.likeCount,
    required super.timeAgo,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] as String,
      userName: json['userName'] as String,
      userImageUrl: json['userImageUrl'] as String,
      rating: json['rating'] as int,
      comment: json['comment'] as String,
      likeCount: json['likeCount'] as int,
      timeAgo: json['timeAgo'] as String,
    );
  }
}
