import 'package:dartz/dartz.dart';
import 'package:ahioma_food_template/core/utils/failures.dart';
import 'package:ahioma_food_template/features/storefront/data/models/storefront_product_model.dart';

/// Abstract repository for search operations
abstract class SearchRepository {
  /// Search products using the given query
  Future<Either<Failure, List<StorefrontProductModel>>> searchProducts(
    String query,
  );

  /// Search wallet transactions using the given query
  Future<Either<Failure, List<Map<String, dynamic>>>> searchWallet(
    String query,
  );

  /// Search orders using the given query
  Future<Either<Failure, List<Map<String, dynamic>>>> searchOrders(
    String query,
  );

  /// Search notifications using the given query
  Future<Either<Failure, List<Map<String, dynamic>>>> searchNotifications(
    String query,
  );
}
