import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/cart.dart';
import '../repositories/cart_repository.dart';

/// Use case for fetching cart
class GetCartUseCase implements UseCase<Cart, NoParams> {
  final CartRepository repository;

  GetCartUseCase(this.repository);

  @override
  Future<Either<Failure, Cart>> call(NoParams params) async {
    return await repository.getCart();
  }
}

/// Parameters for AddToCartUseCase
class AddToCartParams extends Equatable {
  final int productId;
  final int quantity;
  final List<Map<String, dynamic>>? addons;

  const AddToCartParams({
    required this.productId,
    required this.quantity,
    this.addons,
  });

  @override
  List<Object?> get props => [productId, quantity, addons];
}

/// Use case for adding item to cart
class AddToCartUseCase implements UseCase<Cart, AddToCartParams> {
  final CartRepository repository;

  AddToCartUseCase(this.repository);

  @override
  Future<Either<Failure, Cart>> call(AddToCartParams params) async {
    return await repository.addToCart(
      productId: params.productId,
      quantity: params.quantity,
      addons: params.addons,
    );
  }
}

/// Parameters for RemoveFromCartUseCase
class RemoveFromCartParams extends Equatable {
  final int productId;
  final int quantity;

  const RemoveFromCartParams({required this.productId, required this.quantity});

  @override
  List<Object?> get props => [productId, quantity];
}

/// Use case for removing item from cart
class RemoveFromCartUseCase implements UseCase<Cart, RemoveFromCartParams> {
  final CartRepository repository;

  RemoveFromCartUseCase(this.repository);

  @override
  Future<Either<Failure, Cart>> call(RemoveFromCartParams params) async {
    return await repository.removeFromCart(
      productId: params.productId,
      quantity: params.quantity,
    );
  }
}

/// Use case for clearing cart
class ClearCartUseCase implements UseCase<Cart, NoParams> {
  final CartRepository repository;

  ClearCartUseCase(this.repository);

  @override
  Future<Either<Failure, Cart>> call(NoParams params) async {
    return await repository.clearCart();
  }
}
