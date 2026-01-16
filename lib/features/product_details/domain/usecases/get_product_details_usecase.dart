import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/product_details.dart';
import '../repositories/product_details_repository.dart';

/// Parameters for GetProductDetailsUseCase
class ProductDetailsParams extends Equatable {
  final int productId;

  const ProductDetailsParams({required this.productId});

  @override
  List<Object?> get props => [productId];
}

/// Use case for fetching product details
class GetProductDetailsUseCase
    implements UseCase<ProductDetails, ProductDetailsParams> {
  final ProductDetailsRepository repository;

  GetProductDetailsUseCase(this.repository);

  @override
  Future<Either<Failure, ProductDetails>> call(
    ProductDetailsParams params,
  ) async {
    return await repository.getProductDetails(params.productId);
  }
}

/// Use case for fetching product addons
class GetProductAddonsUseCase
    implements UseCase<List<ProductAddon>, ProductDetailsParams> {
  final ProductDetailsRepository repository;

  GetProductAddonsUseCase(this.repository);

  @override
  Future<Either<Failure, List<ProductAddon>>> call(
    ProductDetailsParams params,
  ) async {
    return await repository.getProductAddons(params.productId);
  }
}
