// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_address_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddAddressResponseModel _$AddAddressResponseModelFromJson(
  Map<String, dynamic> json,
) => AddAddressResponseModel(
  id: json['id'] as String,
  address1: json['address1'] as String,
  address2: json['address2'] as String?,
  city: json['city'] as String,
  state: json['state'] as String,
  postalCode: json['postalCode'] as String,
  country: json['country'] as String,
  isDefault: json['isDefault'] as bool? ?? false,
);

Map<String, dynamic> _$AddAddressResponseModelToJson(
  AddAddressResponseModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'address1': instance.address1,
  'address2': instance.address2,
  'city': instance.city,
  'state': instance.state,
  'postalCode': instance.postalCode,
  'country': instance.country,
  'isDefault': instance.isDefault,
};
