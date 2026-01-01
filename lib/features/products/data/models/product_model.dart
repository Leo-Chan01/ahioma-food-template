import 'package:ahioma_food_template/features/products/domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    required super.name,
    required super.price,
    required super.rating,
    required super.reviewCount,
    required super.soldCount,
    required super.images,
    required super.description,
    required super.category,
    super.colors,
    super.sizes,
    super.isFavorite,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['reviewCount'] as int? ?? 0,
      soldCount: json['soldCount'] as int,
      images: (json['images'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      description: json['description'] as String,
      category: json['category'] as String,
      colors: json['colors'] != null
          ? (json['colors'] as List<dynamic>).map((e) => e as String).toList()
          : const [],
      sizes: json['sizes'] != null
          ? (json['sizes'] as List<dynamic>).map((e) => e as String).toList()
          : const [],
      isFavorite: json['isFavorite'] as bool? ?? false,
    );
  }
}
