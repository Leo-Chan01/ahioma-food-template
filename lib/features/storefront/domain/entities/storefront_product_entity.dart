import 'package:equatable/equatable.dart';

class StorefrontProductEntity extends Equatable {
  const StorefrontProductEntity({
    required this.id,
    required this.name,
    required this.slug,
    required this.price,
    this.description,
    this.images = const [],
    this.category,
    this.categoryId,
    this.rating,
    this.reviewCount = 0,
    this.soldCount = 0,
    this.isFeatured = false,
    this.isActive = true,
    this.sku,
    this.stock,
    this.tags = const [],
  });

  final String id;
  final String name;
  final String slug;
  final double price;
  final String? description;
  final List<String> images;
  final String? category;
  final String? categoryId;
  final double? rating;
  final int reviewCount;
  final int soldCount;
  final bool isFeatured;
  final bool isActive;
  final String? sku;
  final int? stock;
  final List<String> tags;

  @override
  List<Object?> get props => [
    id,
    name,
    slug,
    price,
    description,
    images,
    category,
    categoryId,
    rating,
    reviewCount,
    soldCount,
    isFeatured,
    isActive,
    sku,
    stock,
    tags,
  ];
}
