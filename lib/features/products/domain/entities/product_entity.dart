import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  const ProductEntity({
    required this.id,
    required this.name,
    required this.price,
    required this.rating,
    required this.reviewCount,
    required this.soldCount,
    required this.images,
    required this.description,
    required this.category,
    this.colors = const [],
    this.sizes = const [],
    this.isFavorite = false,
  });

  final String id;
  final String name;
  final double price;
  final double rating;
  final int reviewCount;
  final int soldCount;
  final List<String> images;
  final String description;
  final String category;
  final List<String> colors;
  final List<String> sizes;
  final bool isFavorite;

  @override
  List<Object?> get props => [
    id,
    name,
    price,
    rating,
    reviewCount,
    soldCount,
    images,
    description,
    category,
    colors,
    sizes,
    isFavorite,
  ];
}
