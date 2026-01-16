import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/product_details_model.dart';
import '../../domain/entities/product_details.dart';

abstract class ProductDetailsRemoteDataSource {
  Future<ProductDetailsModel> getProductDetails(int productId);
  Future<List<ProductAddon>> getProductAddons(int productId);
}

class ProductDetailsRemoteDataSourceImpl
    implements ProductDetailsRemoteDataSource {
  final ApiClient apiClient;

  ProductDetailsRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<ProductDetailsModel> getProductDetails(int productId) async {
    final response = await apiClient.get(
      ApiConstants.getProductDetails,
      queryParameters: {'product_id': productId},
    );

    if (response is List && response.isNotEmpty) {
      return ProductDetailsModel.fromJson(response[0]);
    }

    if (response is Map<String, dynamic>) {
      return ProductDetailsModel.fromJson(response);
    }

    throw Exception('Invalid product response');
  }

  @override
  Future<List<ProductAddon>> getProductAddons(int productId) async {
    try {
      final response = await apiClient.get(
        ApiConstants.getProductAddons,
        queryParameters: {'product_id2': productId},
      );

      if (response is Map<String, dynamic>) {
        // Parse using the ProductAddonsResponse
        final addonsResponse = ProductAddonsResponse.fromJson(response);
        return addonsResponse.addons;
      }

      if (response is List) {
        // Legacy format
        return response
            .map((json) => ProductAddonModel.fromJson(json))
            .toList();
      }

      return [];
    } catch (e) {
      return [];
    }
  }
}
