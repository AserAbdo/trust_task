import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/product_details.dart';

abstract class ProductDetailsRepository {
  Future<Either<Failure, ProductDetails>> getProductDetails(int productId);
  Future<Either<Failure, List<ProductAddon>>> getProductAddons(int productId);
}
