import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/product_details.dart';
import '../../domain/repositories/product_details_repository.dart';
import '../datasources/product_details_remote_datasource.dart';

class ProductDetailsRepositoryImpl implements ProductDetailsRepository {
  final ProductDetailsRemoteDataSource remoteDataSource;

  ProductDetailsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, ProductDetails>> getProductDetails(
    int productId,
  ) async {
    try {
      final productDetails = await remoteDataSource.getProductDetails(
        productId,
      );
      final addons = await remoteDataSource.getProductAddons(productId);

      // Use copyWithAddons to combine product with addons
      final productWithAddons = productDetails.copyWithAddons(addons);

      return Right(productWithAddons);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ProductAddon>>> getProductAddons(
    int productId,
  ) async {
    try {
      final addons = await remoteDataSource.getProductAddons(productId);
      return Right(addons);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
