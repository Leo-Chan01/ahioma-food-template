import 'package:json_annotation/json_annotation.dart';
import 'package:ahioma_food_template/features/checkout/domain/entities/add_address_request_entity.dart';

part 'add_address_request_model.g.dart';

@JsonSerializable()
class AddAddressRequestModel extends AddAddressRequestEntity {
  const AddAddressRequestModel({
    required super.address1,
    super.address2,
    required super.city,
    required super.state,
    required super.postalCode,
    required super.country,
    super.isDefault,
  });

  factory AddAddressRequestModel.fromJson(Map<String, dynamic> json) =>
      _$AddAddressRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$AddAddressRequestModelToJson(this);
}
