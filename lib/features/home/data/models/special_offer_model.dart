import 'package:ahioma_food_template/features/home/domain/entities/special_offer_entity.dart';

class SpecialOfferModel extends SpecialOfferEntity {
  const SpecialOfferModel({
    required super.id,
    required super.discount,
    required super.title,
    required super.description,
    required super.imageUrl,
    super.isActive,
  });

  factory SpecialOfferModel.fromJson(Map<String, dynamic> json) {
    return SpecialOfferModel(
      id: json['id'] as String,
      discount: json['discount'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      isActive: json['isActive'] as bool? ?? true,
    );
  }
}
