import 'package:json_annotation/json_annotation.dart';
import 'package:ahioma_food_template/features/reviews/domain/entities/create_review_request_entity.dart';

part 'create_review_request_model.g.dart';

@JsonSerializable()
class CreateReviewRequestModel extends CreateReviewRequestEntity {
  const CreateReviewRequestModel({
    required super.rating,
    required super.title,
    required super.comment,
  });

  factory CreateReviewRequestModel.fromJson(Map<String, dynamic> json) =>
      _$CreateReviewRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$CreateReviewRequestModelToJson(this);
}
