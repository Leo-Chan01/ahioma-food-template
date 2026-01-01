import 'package:json_annotation/json_annotation.dart';
import 'package:ahioma_food_template/features/checkout/domain/entities/add_address_response_entity.dart';

part 'add_address_response_model.g.dart';

@JsonSerializable()
class AddAddressResponseModel extends AddAddressResponseEntity {
  const AddAddressResponseModel({
    required super.id,
    required super.address1,
    super.address2,
    required super.city,
    required super.state,
    required super.postalCode,
    required super.country,
    super.isDefault,
  });

  factory AddAddressResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AddAddressResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$AddAddressResponseModelToJson(this);
}
