import 'package:equatable/equatable.dart';

class ReviewEntity extends Equatable {
  const ReviewEntity({
    required this.orderId,
    required this.rating,
    required this.comment,
  });

  final String orderId;
  final int rating;
  final String comment;

  @override
  List<Object?> get props => [orderId, rating, comment];
}
