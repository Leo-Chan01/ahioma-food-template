import 'package:flutter/foundation.dart';
import 'package:ahioma_food_template/features/cart/domain/entities/product/product_item_entity.dart';

class ProductItemModel extends ProductItemEntity {
  const ProductItemModel({
    required super.id,
    required super.name,
    required super.description,
    required super.price,
    required super.imageUrl,
  });

  factory ProductItemModel.fromJson(Map<String, dynamic> json) {
    // Handle imageUrl - could be imageUrl, image, or first image from images array
    var imageUrl = json['imageUrl']?.toString() ?? json['image']?.toString();

    // If no direct imageUrl, check the images array
    if (imageUrl == null || imageUrl.isEmpty) {
      if (json['images'] is List) {
        final images = json['images'] as List;
        if (images.isNotEmpty) {
          // Get first image from array
          final firstImage = images.first;
          if (firstImage != null) {
            imageUrl = firstImage.toString();
          }
        }
      }
    }

    if (kDebugMode && imageUrl == null) {
      debugPrint('[ProductItemModel] No image found in JSON: ${json.keys}');
      debugPrint('[ProductItemModel] images field: ${json['images']}');
    }

    return ProductItemModel(
      id: json['id']?.toString() ?? json['productId']?.toString(),
      name: json['name']?.toString() ?? json['productName']?.toString(),
      description:
          json['description']?.toString() ??
          json['shortDescription']?.toString() ??
          '',
      price:
          (json['price'] as num?)?.toDouble() ??
          (json['unitPrice'] as num?)?.toDouble() ??
          (json['productPrice'] as num?)?.toDouble() ??
          0.0,
      imageUrl: imageUrl ?? '',
    );
  }
}
