import 'package:equatable/equatable.dart';

class AddAddressRequestEntity extends Equatable {
  const AddAddressRequestEntity({
    required this.address1,
    this.address2,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
    this.isDefault = false,
  });

  final String address1;
  final String? address2;
  final String city;
  final String state;
  final String postalCode;
  final String country;
  final bool isDefault;

  @override
  List<Object?> get props => [
        address1,
        address2,
        city,
        state,
        postalCode,
        country,
        isDefault,
      ];
}

