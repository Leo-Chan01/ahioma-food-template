import 'package:ahioma_food_template/features/checkout/data/models/add_address_response_model.dart';
import 'package:ahioma_food_template/features/checkout/domain/entities/shipping_address_entity.dart';

class ShippingAddressModel extends ShippingAddressEntity {
  const ShippingAddressModel({
    required super.id,
    required super.label,
    required super.address,
    super.isDefault,
  });

  factory ShippingAddressModel.fromJson(Map<String, dynamic> json) {
    return ShippingAddressModel(
      id: json['id'] as String,
      label: json['label'] as String,
      address: json['address'] as String,
      isDefault: json['isDefault'] as bool? ?? false,
    );
  }

  /// Create ShippingAddressModel from AddAddressResponseModel
  /// Combines address fields into a formatted address string
  factory ShippingAddressModel.fromAddAddressResponse(
    AddAddressResponseModel address,
  ) {
    // Build formatted address string
    final addressParts = <String>[
      address.address1,
      if (address.address2 != null && address.address2!.isNotEmpty)
        address.address2!,
      address.city,
      address.state,
      address.postalCode,
      address.country,
    ];
    final formattedAddress = addressParts.join(', ');

    // Use city as label, or create a default label
    final label = address.city.isNotEmpty ? address.city : 'Address';

    return ShippingAddressModel(
      id: address.id,
      label: label,
      address: formattedAddress,
      isDefault: address.isDefault,
    );
  }
}
