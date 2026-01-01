import 'package:dartz/dartz.dart';
import 'package:ahioma_food_template/core/utils/failures.dart';

abstract class WalletRepository {
  Future<Either<Failure, Map<String, dynamic>>> initializePayment();
  Future<Either<Failure, double>> getWalletBalance();
  Future<Either<Failure, List<Map<String, dynamic>>>> getTransactions();
}
