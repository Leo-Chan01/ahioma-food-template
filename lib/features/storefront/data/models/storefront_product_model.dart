import 'package:ahioma_food_template/features/storefront/domain/entities/storefront_product_entity.dart';

class StorefrontProductModel extends StorefrontProductEntity {
  const StorefrontProductModel({
    required super.id,
    required super.name,
    required super.slug,
    required super.price,
    super.description,
    super.images,
    super.category,
    super.categoryId,
    super.rating,
    super.reviewCount,
    super.soldCount,
    super.isFeatured,
    super.isActive,
    super.sku,
    super.stock,
    super.tags,
  });

  factory StorefrontProductModel.fromJson(Map<String, dynamic> json) {
    // Handle images - could be a list of strings or list of objects with url
    var imagesList = <String>[];
    if (json['images'] != null) {
      final imagesData = json['images'];
      if (imagesData is List) {
        imagesList = imagesData.map<String>((img) {
          if (img is String) {
            return img;
          } else if (img is Map && img['url'] != null) {
            return img['url'] as String;
          } else if (img is Map && img['imageUrl'] != null) {
            return img['imageUrl'] as String;
          }
          return img.toString();
        }).toList();
      }
    }

    // Handle tags
    var tagsList = <String>[];
    if (json['tags'] != null) {
      final tagsData = json['tags'];
      if (tagsData is List) {
        tagsList = tagsData.map<String>((tag) {
          if (tag is String) {
            return tag;
          } else if (tag is Map && tag['name'] != null) {
            return tag['name'] as String;
          }
          return tag.toString();
        }).toList();
      }
    }

    // Handle rating - can be a number or an object with 'average' field
    double? ratingValue;
    var reviewCountFromRating = 0;
    if (json['rating'] != null) {
      if (json['rating'] is num) {
        ratingValue = (json['rating'] as num).toDouble();
      } else if (json['rating'] is Map) {
        final ratingMap = json['rating'] as Map<String, dynamic>;
        final average = ratingMap['average'];
        if (average != null) {
          ratingValue = average is num
              ? average.toDouble()
              : double.tryParse(average.toString());
        }
        reviewCountFromRating =
            ratingMap['totalReviews'] as int? ??
            ratingMap['total_reviews'] as int? ??
            0;
      }
    }

    // Handle soldCount - can be soldCount, totalSold, or sold_count
    final soldCount =
        json['soldCount'] as int? ??
        json['totalSold'] as int? ??
        json['sold_count'] as int? ??
        json['total_sold'] as int? ??
        0;

    // Handle reviewCount - check rating object first, then direct fields
    final reviewCount =
        json['reviewCount'] as int? ??
        json['review_count'] as int? ??
        reviewCountFromRating;

    // Handle price - can be price or finalPrice
    final priceValue =
        (json['price'] as num?)?.toDouble() ??
        (json['finalPrice'] as num?)?.toDouble() ??
        0.0;

    return StorefrontProductModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      price: priceValue,
      description: json['description']?.toString(),
      images: imagesList,
      category: json['category'] is Map
          ? json['category']['name']?.toString()
          : json['category']?.toString(),
      categoryId:
          json['categoryId']?.toString() ??
          (json['category'] is Map ? json['category']['id']?.toString() : null),
      rating: ratingValue,
      reviewCount: reviewCount,
      soldCount: soldCount,
      isFeatured:
          json['isFeatured'] as bool? ?? json['featured'] as bool? ?? false,
      isActive: json['isActive'] as bool? ?? json['active'] as bool? ?? true,
      sku: json['sku']?.toString(),
      stock: json['stock'] as int?,
      tags: tagsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'price': price,
      if (description != null) 'description': description,
      'images': images,
      if (category != null) 'category': category,
      if (categoryId != null) 'categoryId': categoryId,
      if (rating != null) 'rating': rating,
      'reviewCount': reviewCount,
      'soldCount': soldCount,
      'isFeatured': isFeatured,
      'isActive': isActive,
      if (sku != null) 'sku': sku,
      if (stock != null) 'stock': stock,
      'tags': tags,
    };
  }

  /// Convert to the existing ProductEntity format for compatibility
  Map<String, dynamic> toProductEntityJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'rating': rating ?? 0.0,
      'reviewCount': reviewCount,
      'soldCount': soldCount,
      'images': images.isNotEmpty
          ? images
          : <String>['https://via.placeholder.com/400'],
      'description': description ?? '',
      'category': category ?? categoryId ?? '',
      'colors': <String>[],
      'sizes': <String>[],
      'isFavorite': false,
    };
  }
}
