import 'package:dartz/dartz.dart';
import 'package:ahioma_food_template/core/error/error_handler.dart';
import 'package:ahioma_food_template/core/utils/type_defs.dart';
import 'package:ahioma_food_template/features/cart/data/data_sources/local/cart_local_source.dart';
import 'package:ahioma_food_template/features/cart/data/data_sources/remote/cart_remote_data_source.dart';
import 'package:ahioma_food_template/features/cart/data/models/cart/cart_item_model.dart';
import 'package:ahioma_food_template/features/cart/domain/repository/cart_respository.dart';

class CartRepositoryImpl implements CartRespository {
  CartRepositoryImpl({
    this.localDataSource,
    this.remoteDataSource,
  });

  final CartLocalSource? localDataSource;
  final CartRemoteDataSource? remoteDataSource;

  @override
  FutureEither<List<CartItemModel>?> getCartItems() async {
    try {
      // Use Cart Remote Data Source (handles both guest and authenticated cart)
      if (remoteDataSource != null) {
        final items = await remoteDataSource!.getCartItems();
        return Right(items);
      }

      // Fallback to local storage
      final items = await localDataSource?.getCartItems();
      return Right(items);
    } catch (e, stackTrace) {
      final failure = ErrorHandler.handleException(e, stackTrace);
      ErrorHandler.logError(
        e,
        stackTrace: stackTrace,
        context: 'CartRepositoryImpl.getCartItems',
      );
      return Left(failure);
    }
  }

  @override
  FutureEither<void> addToCart(String productId, {int quantity = 1}) async {
    try {
      if (remoteDataSource != null) {
        await remoteDataSource!.addToCart(
          productId: productId,
          quantity: quantity,
        );
        return const Right(null);
      }

      // Fallback: could add to local storage if needed
      return const Right(null);
    } catch (e, stackTrace) {
      final failure = ErrorHandler.handleException(e, stackTrace);
      ErrorHandler.logError(
        e,
        stackTrace: stackTrace,
        context: 'CartRepositoryImpl.addToCart',
      );
      return Left(failure);
    }
  }

  @override
  FutureEither<void> clearCart() async {
    try {
      if (remoteDataSource != null) {
        await remoteDataSource!.clearCart();
        return const Right(null);
      }

      // Fallback: clear local storage if needed
      return const Right(null);
    } catch (e, stackTrace) {
      final failure = ErrorHandler.handleException(e, stackTrace);
      ErrorHandler.logError(
        e,
        stackTrace: stackTrace,
        context: 'CartRepositoryImpl.clearCart',
      );
      return Left(failure);
    }
  }

  @override
  FutureEither<void> removeFromCart(String itemId) async {
    try {
      if (remoteDataSource != null) {
        await remoteDataSource!.removeCartItem(itemId);
        return const Right(null);
      }

      // Fallback: remove from local storage if needed
      return const Right(null);
    } catch (e, stackTrace) {
      final failure = ErrorHandler.handleException(e, stackTrace);
      ErrorHandler.logError(
        e,
        stackTrace: stackTrace,
        context: 'CartRepositoryImpl.removeFromCart',
      );
      return Left(failure);
    }
  }

  /// Update cart item quantity
  @override
  FutureEither<void> updateCartItemQuantity({
    required String itemId,
    required int quantity,
  }) async {
    try {
      if (remoteDataSource != null) {
        await remoteDataSource!.updateCartItem(
          itemId: itemId,
          quantity: quantity,
        );
        return const Right(null);
      }

      return const Right(null);
    } catch (e, stackTrace) {
      final failure = ErrorHandler.handleException(e, stackTrace);
      ErrorHandler.logError(
        e,
        stackTrace: stackTrace,
        context: 'CartRepositoryImpl.updateCartItemQuantity',
      );
      return Left(failure);
    }
  }
}
