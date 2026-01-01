import 'package:dartz/dartz.dart';
import 'package:ahioma_food_template/core/utils/failures.dart';

/// Represents a value that can be either a Failure or a Success
typedef FutureEither<T> = Future<Either<Failure, T>>;

/// Represents a synchronous Either result
typedef SyncEither<T> = Either<Failure, T>;
