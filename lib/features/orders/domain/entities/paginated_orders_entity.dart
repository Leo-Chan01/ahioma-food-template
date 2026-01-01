import 'package:equatable/equatable.dart';
import 'package:ahioma_food_template/features/orders/domain/entities/order_entity.dart';
import 'package:ahioma_food_template/features/orders/domain/entities/pagination_entity.dart';

class PaginatedOrdersEntity extends Equatable {
  const PaginatedOrdersEntity({required this.orders, required this.pagination});

  final List<OrderEntity> orders;
  final PaginationEntity pagination;

  @override
  List<Object?> get props => [orders, pagination];
}
