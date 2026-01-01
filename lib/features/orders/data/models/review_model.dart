import 'package:ahioma_food_template/features/orders/domain/entities/review_entity.dart';

class ReviewModel extends ReviewEntity {
  const ReviewModel({
    required super.orderId,
    required super.rating,
    required super.comment,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      orderId: json['orderId'] as String,
      rating: json['rating'] as int,
      comment: json['comment'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'rating': rating,
      'comment': comment,
    };
  }
}
