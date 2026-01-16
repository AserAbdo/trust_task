import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/cart.dart';
import '../repositories/cart_repository.dart';

class GetCartUseCase {
  final CartRepository repository;

  GetCartUseCase(this.repository);

  Future<Either<Failure, Cart>> call() async {
    return await repository.getCart();
  }
}

class AddToCartUseCase {
  final CartRepository repository;

  AddToCartUseCase(this.repository);

  Future<Either<Failure, Cart>> call({
    required int productId,
    required int quantity,
    List<Map<String, dynamic>>? addons,
  }) async {
    return await repository.addToCart(
      productId: productId,
      quantity: quantity,
      addons: addons,
    );
  }
}

class RemoveFromCartUseCase {
  final CartRepository repository;

  RemoveFromCartUseCase(this.repository);

  Future<Either<Failure, Cart>> call({
    required int productId,
    required int quantity,
  }) async {
    return await repository.removeFromCart(
      productId: productId,
      quantity: quantity,
    );
  }
}

class ClearCartUseCase {
  final CartRepository repository;

  ClearCartUseCase(this.repository);

  Future<Either<Failure, Cart>> call() async {
    return await repository.clearCart();
  }
}
