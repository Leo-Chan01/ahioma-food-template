import 'package:json_annotation/json_annotation.dart';
import 'package:ahioma_food_template/features/reviews/domain/entities/update_review_request_entity.dart';

part 'update_review_request_model.g.dart';

@JsonSerializable()
class UpdateReviewRequestModel extends UpdateReviewRequestEntity {
  const UpdateReviewRequestModel({
    required super.rating,
    required super.title,
    required super.comment,
  });

  factory UpdateReviewRequestModel.fromJson(Map<String, dynamic> json) =>
      _$UpdateReviewRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateReviewRequestModelToJson(this);
}
