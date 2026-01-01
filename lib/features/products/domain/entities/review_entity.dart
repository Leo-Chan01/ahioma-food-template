import 'package:equatable/equatable.dart';

class ReviewEntity extends Equatable {
  const ReviewEntity({
    required this.id,
    required this.userName,
    required this.userImageUrl,
    required this.rating,
    required this.comment,
    required this.likeCount,
    required this.timeAgo,
  });

  final String id;
  final String userName;
  final String userImageUrl;
  final int rating;
  final String comment;
  final int likeCount;
  final String timeAgo;

  @override
  List<Object?> get props => [
    id,
    userName,
    userImageUrl,
    rating,
    comment,
    likeCount,
    timeAgo,
  ];
}
