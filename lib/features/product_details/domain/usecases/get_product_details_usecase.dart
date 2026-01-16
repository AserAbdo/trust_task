import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/product_details.dart';
import '../repositories/product_details_repository.dart';

class GetProductDetailsUseCase {
  final ProductDetailsRepository repository;

  GetProductDetailsUseCase(this.repository);

  Future<Either<Failure, ProductDetails>> call(int productId) async {
    return await repository.getProductDetails(productId);
  }
}

class GetProductAddonsUseCase {
  final ProductDetailsRepository repository;

  GetProductAddonsUseCase(this.repository);

  Future<Either<Failure, List<ProductAddon>>> call(int productId) async {
    return await repository.getProductAddons(productId);
  }
}
