import 'package:equatable/equatable.dart';

class SearchFilterEntity extends Equatable {
  const SearchFilterEntity({
    this.selectedCategory,
    this.minPrice = 0.0,
    this.maxPrice = 1000.0,
    this.sortBy,
    this.minRating,
    this.categories = const [],
    this.sortOptions = const [],
    this.ratingOptions = const [],
  });

  final String? selectedCategory;
  final double minPrice;
  final double maxPrice;
  final String? sortBy;
  final double? minRating;
  final List<String> categories;
  final List<String> sortOptions;
  final List<String> ratingOptions;

  SearchFilterEntity copyWith({
    String? selectedCategory,
    double? minPrice,
    double? maxPrice,
    String? sortBy,
    double? minRating,
    List<String>? categories,
    List<String>? sortOptions,
    List<String>? ratingOptions,
  }) {
    return SearchFilterEntity(
      selectedCategory: selectedCategory ?? this.selectedCategory,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      sortBy: sortBy ?? this.sortBy,
      minRating: minRating ?? this.minRating,
      categories: categories ?? this.categories,
      sortOptions: sortOptions ?? this.sortOptions,
      ratingOptions: ratingOptions ?? this.ratingOptions,
    );
  }

  @override
  List<Object?> get props => [
    selectedCategory,
    minPrice,
    maxPrice,
    sortBy,
    minRating,
    categories,
    sortOptions,
    ratingOptions,
  ];
}
