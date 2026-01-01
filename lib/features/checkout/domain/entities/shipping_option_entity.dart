import 'package:equatable/equatable.dart';

class ShippingOptionEntity extends Equatable {
  const ShippingOptionEntity({
    required this.id,
    required this.name,
    required this.price,
    required this.estimatedArrival,
    required this.iconName,
  });

  final String id;
  final String name;
  final double price;
  final String estimatedArrival;
  final String iconName;

  @override
  List<Object?> get props => [id, name, price, estimatedArrival, iconName];
}
