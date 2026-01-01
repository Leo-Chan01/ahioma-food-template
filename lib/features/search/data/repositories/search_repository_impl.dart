import 'package:dartz/dartz.dart';
import 'package:ahioma_food_template/features/storefront/data/data_sources/remote/storefront_remote_data_source.dart';
import 'package:ahioma_food_template/core/utils/failures.dart';
import 'package:ahioma_food_template/features/fund_management/data/data_sources/local/wallet_local_source.dart';
import 'package:ahioma_food_template/features/orders/data/data_sources/local/orders_local_source.dart';
import 'package:ahioma_food_template/features/search/domain/repositories/search_repository.dart';
import 'package:ahioma_food_template/features/storefront/data/models/storefront_product_model.dart';
import 'package:ahioma_food_template/injection_container.dart';

class SearchRepositoryImpl implements SearchRepository {
  final StorefrontRemoteDataSource _storefrontDataSource =
      sl<StorefrontRemoteDataSource>();
  final WalletLocalSource _walletSource = WalletLocalSource();
  final OrdersLocalSource _ordersSource = OrdersLocalSource();

  @override
  Future<Either<Failure, List<StorefrontProductModel>>> searchProducts(
    String query,
  ) async {
    try {
      final products = await _storefrontDataSource.searchProducts(query: query);
      return Right(products);
    } catch (e) {
      return const Left(ServerFailure(message: 'Failed to search products'));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> searchWallet(
    String query,
  ) async {
    try {
      // Simulate search delay
      await Future<void>.delayed(const Duration(milliseconds: 300));

      final transactions = await _walletSource.getTransactions();
      final queryLower = query.toLowerCase();

      final results = transactions
          .where(
            (transaction) =>
                transaction.title.toLowerCase().contains(queryLower) ||
                (transaction.productName?.toLowerCase().contains(queryLower) ??
                    false),
          )
          .map<Map<String, dynamic>>(
            (t) => {
              'id': t.id,
              'title': t.title,
              'amount': t.amount,
              'date': t.date,
              'time': t.time,
              'type': t.type.toString().split('.').last,
              'imageUrl': t.imageUrl,
              'productName': t.productName,
            },
          )
          .toList();

      return Right(results);
    } catch (e) {
      return const Left(ServerFailure(message: 'Failed to search wallet'));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> searchOrders(
    String query,
  ) async {
    try {
      // Simulate search delay
      await Future<void>.delayed(const Duration(milliseconds: 300));

      final ongoingOrders = await _ordersSource.getOngoingOrders();
      final completedOrders = await _ordersSource.getCompletedOrders();
      final allOrders = [...ongoingOrders, ...completedOrders];
      final queryLower = query.toLowerCase();

      final results = allOrders
          .where(
            (order) =>
                order.productName.toLowerCase().contains(queryLower) ||
                order.status.toString().toLowerCase().contains(queryLower),
          )
          .map<Map<String, dynamic>>(
            (o) => {
              'id': o.id,
              'productName': o.productName,
              'productImage': o.productImage,
              'price': o.price,
              'status': o.status.toString().split('.').last,
            },
          )
          .toList();

      return Right(results);
    } catch (e) {
      return const Left(ServerFailure(message: 'Failed to search orders'));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> searchNotifications(
    String query,
  ) async {
    try {
      // Simulate search delay
      await Future<void>.delayed(const Duration(milliseconds: 300));

      // Mock notification search results
      final results = <Map<String, dynamic>>[];

      return Right(results);
    } catch (e) {
      return const Left(
        ServerFailure(message: 'Failed to search notifications'),
      );
    }
  }
}
