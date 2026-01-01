// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_review_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateReviewRequestModel _$CreateReviewRequestModelFromJson(
  Map<String, dynamic> json,
) => CreateReviewRequestModel(
  rating: (json['rating'] as num).toInt(),
  title: json['title'] as String,
  comment: json['comment'] as String,
);

Map<String, dynamic> _$CreateReviewRequestModelToJson(
  CreateReviewRequestModel instance,
) => <String, dynamic>{
  'rating': instance.rating,
  'title': instance.title,
  'comment': instance.comment,
};
