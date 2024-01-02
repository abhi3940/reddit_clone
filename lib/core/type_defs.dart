import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/core/failure.dart';

// Type alias for Future that can be Failure or T
typedef FutureEither<T> = Future<Either<Failure, T>>;

// Type alias for Future that can be Failure or void
typedef FutureEitherVoid = FutureEither<void>;