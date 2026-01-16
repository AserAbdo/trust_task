import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/cart.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/cart_remote_datasource.dart';

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource remoteDataSource;

  CartRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Cart>> getCart() async {
    try {
      final cart = await remoteDataSource.getCart();
      return Right(cart);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Cart>> addToCart({
    required int productId,
    required int quantity,
    List<Map<String, dynamic>>? addons,
  }) async {
    try {
      final cart = await remoteDataSource.addToCart(
        productId: productId,
        quantity: quantity,
        addons: addons,
      );
      return Right(cart);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Cart>> removeFromCart({
    required int productId,
    required int quantity,
  }) async {
    try {
      final cart = await remoteDataSource.removeFromCart(
        productId: productId,
        quantity: quantity,
      );
      return Right(cart);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Cart>> clearCart() async {
    try {
      final cart = await remoteDataSource.clearCart();
      return Right(cart);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
