import 'package:ahioma_food_template/features/orders/data/models/order_model.dart';
import 'package:ahioma_food_template/features/orders/data/models/pagination_model.dart';
import 'package:ahioma_food_template/features/orders/domain/entities/paginated_orders_entity.dart';

class PaginatedOrdersModel extends PaginatedOrdersEntity {
  const PaginatedOrdersModel({
    required super.orders,
    required super.pagination,
  });

  factory PaginatedOrdersModel.fromJson(Map<String, dynamic> json) {
    final ordersList = json['orders'] as List<dynamic>? ?? [];
    final orders = ordersList
        .map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
        .toList();

    final paginationJson = json['pagination'] as Map<String, dynamic>? ?? {};
    final pagination = PaginationModel.fromJson(paginationJson);

    return PaginatedOrdersModel(orders: orders, pagination: pagination);
  }

  Map<String, dynamic> toJson() {
    return {
      'orders': orders.map((e) => (e as OrderModel).toJson()).toList(),
      'pagination': (pagination as PaginationModel).toJson(),
    };
  }
}
