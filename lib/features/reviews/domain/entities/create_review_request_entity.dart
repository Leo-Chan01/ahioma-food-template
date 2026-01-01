import 'package:equatable/equatable.dart';

class CreateReviewRequestEntity extends Equatable {
  const CreateReviewRequestEntity({
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

