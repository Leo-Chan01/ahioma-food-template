// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_review_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateReviewRequestModel _$UpdateReviewRequestModelFromJson(
  Map<String, dynamic> json,
) => UpdateReviewRequestModel(
  rating: (json['rating'] as num).toInt(),
  title: json['title'] as String,
  comment: json['comment'] as String,
);

Map<String, dynamic> _$UpdateReviewRequestModelToJson(
  UpdateReviewRequestModel instance,
) => <String, dynamic>{
  'rating': instance.rating,
  'title': instance.title,
  'comment': instance.comment,
};
