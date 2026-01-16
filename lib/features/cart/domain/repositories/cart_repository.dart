import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/cart.dart';

abstract class CartRepository {
  Future<Either<Failure, Cart>> getCart();
  Future<Either<Failure, Cart>> addToCart({
    required int productId,
    required int quantity,
    List<Map<String, dynamic>>? addons,
  });
  Future<Either<Failure, Cart>> removeFromCart({
    required int productId,
    required int quantity,
  });
  Future<Either<Failure, Cart>> clearCart();
}
