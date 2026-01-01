import 'package:flutter/material.dart';
import 'package:ahioma_food_template/features/orders/domain/entities/order_entity.dart';
import 'package:ahioma_food_template/features/orders/domain/entities/review_entity.dart';
import 'package:ahioma_food_template/features/orders/domain/repository/orders_repository.dart';
import 'package:ahioma_food_template/injection_container.dart';

class OrdersProvider extends ChangeNotifier {
  final OrdersRepository _repository = sl<OrdersRepository>();

  List<OrderEntity> _ongoingOrders = [];
  List<OrderEntity> _completedOrders = [];
  OrderEntity? _currentOrder;
  bool _isLoading = false;
  String? _error;

  List<OrderEntity> get ongoingOrders => _ongoingOrders;
  List<OrderEntity> get completedOrders => _completedOrders;
  OrderEntity? get currentOrder => _currentOrder;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  Future<void> loadOngoingOrders() async {
    _setLoading(true);
    _setError(null);
    try {
      // Use API endpoint to get all orders, then filter for ongoing
      // Fetch without status filter to get all orders, then filter by status
      final result = await _repository.getCustomerOrders(
        page: 1,
        limit: 100,
      );
      // Filter orders where status is ongoing (PENDING, PROCESSING, SHIPPED)
      _ongoingOrders = result.orders
          .where((order) => order.status == OrderStatus.ongoing)
          .toList();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadCompletedOrders() async {
    _setLoading(true);
    _setError(null);
    try {
      // Use API endpoint to get all orders, then filter for completed
      // Fetch without status filter to get all orders, then filter by status
      final result = await _repository.getCustomerOrders(
        page: 1,
        limit: 100,
      );
      // Filter orders where status is completed (COMPLETED, DELIVERED)
      _completedOrders = result.orders
          .where((order) => order.status == OrderStatus.completed)
          .toList();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadOrderById(String orderId) async {
    _setLoading(true);
    _setError(null);
    try {
      _currentOrder = await _repository.getOrderById(orderId);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> submitReview(ReviewEntity review) async {
    _setLoading(true);
    _setError(null);
    try {
      await _repository.submitReview(review);
      // Reload orders after submitting review
      await loadCompletedOrders();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }
}
