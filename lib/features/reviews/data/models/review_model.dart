import 'package:ahioma_food_template/features/reviews/domain/entities/review_entity.dart';

class ReviewModel extends ReviewEntity {
  const ReviewModel({
    required super.id,
    required super.productId,
    required super.productName,
    required super.productImage,
    required super.rating,
    required super.title,
    required super.comment,
    required super.status,
    required super.createdAt,
    required super.updatedAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    // Extract product info if nested
    String productId = json['productId'] as String? ?? '';
    String productName = 'Unknown Product';
    String productImage = '';

    if (json['product'] is Map) {
      final product = json['product'] as Map<String, dynamic>;
      productId = product['id']?.toString() ?? productId;
      productName = product['name']?.toString() ?? productName;
      final images = product['images'] as List<dynamic>?;
      if (images != null && images.isNotEmpty) {
        productImage = images[0].toString();
      }
    }

    return ReviewModel(
      id: json['id'] as String? ?? '',
      productId: productId,
      productName: productName,
      productImage: productImage,
      rating: (json['rating'] as num?)?.toInt() ?? 0,
      title: json['title'] as String? ?? '',
      comment: json['comment'] as String? ?? '',
      status: json['status'] as String? ?? 'PENDING',
      createdAt: json['createdAt'] as String? ?? '',
      updatedAt: json['updatedAt'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'productName': productName,
      'productImage': productImage,
      'rating': rating,
      'title': title,
      'comment': comment,
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
