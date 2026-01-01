import 'package:equatable/equatable.dart';

class UpdateReviewRequestEntity extends Equatable {
  const UpdateReviewRequestEntity({
    required this.rating,
    required this.title,
    required this.comment,
  });

  final int rating;
  final String title;
  final String comment;

  @override
  List<Object?> get props => [rating, title, comment];
}

