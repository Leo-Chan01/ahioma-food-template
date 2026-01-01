import 'package:dartz/dartz.dart';
import 'package:ahioma_food_template/core/error/error_handler.dart';
import 'package:ahioma_food_template/core/utils/type_defs.dart';
import 'package:ahioma_food_template/features/storefront/domain/entities/storefront_product_entity.dart';
import 'package:ahioma_food_template/features/wishlist/data/data_sources/remote/wishlist_remote_data_source.dart';
import 'package:ahioma_food_template/features/wishlist/domain/repository/wishlist_repository.dart';

class WishlistRepositoryImpl implements WishlistRepository {
  WishlistRepositoryImpl({
    required this.remoteDataSource,
  });

  final WishlistRemoteDataSource remoteDataSource;

  @override
  FutureEither<List<StorefrontProductEntity>> getWishlist() async {
    try {
      final products = await remoteDataSource.getWishlist();
      return Right(products);
    } catch (e, stackTrace) {
      final failure = ErrorHandler.handleException(e, stackTrace);
      ErrorHandler.logError(
        e,
        stackTrace: stackTrace,
        context: 'WishlistRepositoryImpl.getWishlist',
      );
      return Left(failure);
    }
  }

  @override
  FutureEither<StorefrontProductEntity> addToWishlist(String productId) async {
    try {
      final product = await remoteDataSource.addToWishlist(
        productId: productId,
      );
      return Right(product);
    } catch (e, stackTrace) {
      final failure = ErrorHandler.handleException(e, stackTrace);
      ErrorHandler.logError(
        e,
        stackTrace: stackTrace,
        context: 'WishlistRepositoryImpl.addToWishlist',
      );
      return Left(failure);
    }
  }

  @override
  FutureEither<void> removeFromWishlist(String productId) async {
    try {
      await remoteDataSource.removeFromWishlist(productId);
      return const Right(null);
    } catch (e, stackTrace) {
      final failure = ErrorHandler.handleException(e, stackTrace);
      ErrorHandler.logError(
        e,
        stackTrace: stackTrace,
        context: 'WishlistRepositoryImpl.removeFromWishlist',
      );
      return Left(failure);
    }
  }
}
