import 'package:equatable/equatable.dart';

class SpecialOfferEntity extends Equatable {
  const SpecialOfferEntity({
    required this.id,
    required this.discount,
    required this.title,
    required this.description,
    required this.imageUrl,
    this.isActive = true,
  });

  final String id;
  final String discount;
  final String title;
  final String description;
  final String imageUrl;
  final bool isActive;

  @override
  List<Object?> get props => [
    id,
    discount,
    title,
    description,
    imageUrl,
    isActive,
  ];
}
