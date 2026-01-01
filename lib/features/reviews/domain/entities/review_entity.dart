import 'package:equatable/equatable.dart';

class ReviewEntity extends Equatable {
  const ReviewEntity({
    required this.id,
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.rating,
    required this.title,
    required this.comment,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String productId;
  final String productName;
  final String productImage;
  final int rating;
  final String title;
  final String comment;
  final String status; // PENDING, APPROVED, REJECTED
  final String createdAt;
  final String updatedAt;

  @override
  List<Object?> get props => [
        id,
        productId,
        productName,
        productImage,
        rating,
        title,
        comment,
        status,
        createdAt,
        updatedAt,
      ];
}

