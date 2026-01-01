import 'package:equatable/equatable.dart';

class ShippingAddressEntity extends Equatable {
  const ShippingAddressEntity({
    required this.id,
    required this.label,
    required this.address,
    this.isDefault = false,
  });

  final String id;
  final String label;
  final String address;
  final bool isDefault;

  @override
  List<Object?> get props => [id, label, address, isDefault];
}
