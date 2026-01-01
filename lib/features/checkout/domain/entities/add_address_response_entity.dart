import 'package:equatable/equatable.dart';

class AddAddressResponseEntity extends Equatable {
  const AddAddressResponseEntity({
    required this.id,
    required this.address1,
    this.address2,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
    this.isDefault = false,
  });

  final String id;
  final String address1;
  final String? address2;
  final String city;
  final String state;
  final String postalCode;
  final String country;
  final bool isDefault;

  @override
  List<Object?> get props => [
        id,
        address1,
        address2,
        city,
        state,
        postalCode,
        country,
        isDefault,
      ];
}

