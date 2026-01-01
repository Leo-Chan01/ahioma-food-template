// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_address_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddAddressRequestModel _$AddAddressRequestModelFromJson(
  Map<String, dynamic> json,
) => AddAddressRequestModel(
  address1: json['address1'] as String,
  address2: json['address2'] as String?,
  city: json['city'] as String,
  state: json['state'] as String,
  postalCode: json['postalCode'] as String,
  country: json['country'] as String,
  isDefault: json['isDefault'] as bool? ?? false,
);

Map<String, dynamic> _$AddAddressRequestModelToJson(
  AddAddressRequestModel instance,
) => <String, dynamic>{
  'address1': instance.address1,
  'address2': instance.address2,
  'city': instance.city,
  'state': instance.state,
  'postalCode': instance.postalCode,
  'country': instance.country,
  'isDefault': instance.isDefault,
};
