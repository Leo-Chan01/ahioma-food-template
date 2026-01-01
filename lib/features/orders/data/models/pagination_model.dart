import 'package:ahioma_food_template/features/orders/domain/entities/pagination_entity.dart';

class PaginationModel extends PaginationEntity {
  const PaginationModel({
    required super.total,
    required super.page,
    required super.limit,
    required super.totalPages,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
      total: json['total'] as int? ?? 0,
      page: json['page'] as int? ?? 1,
      limit: json['limit'] as int? ?? 20,
      totalPages: json['totalPages'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'page': page,
      'limit': limit,
      'totalPages': totalPages,
    };
  }
}
