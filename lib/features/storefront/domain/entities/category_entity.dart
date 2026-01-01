import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  const CategoryEntity({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    this.imageUrl,
    this.parentId,
    this.isActive = true,
  });

  final String id;
  final String name;
  final String slug;
  final String? description;
  final String? imageUrl;
  final String? parentId;
  final bool isActive;

  @override
  List<Object?> get props => [
    id,
    name,
    slug,
    description,
    imageUrl,
    parentId,
    isActive,
  ];
}
