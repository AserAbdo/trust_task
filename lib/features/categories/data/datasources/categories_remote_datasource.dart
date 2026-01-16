import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/category_model.dart';

abstract class CategoriesRemoteDataSource {
  Future<List<CategoryModel>> getCategories();
}

class CategoriesRemoteDataSourceImpl implements CategoriesRemoteDataSource {
  final ApiClient apiClient;

  CategoriesRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<CategoryModel>> getCategories() async {
    final response = await apiClient.get(ApiConstants.getCategories);

    if (response is List) {
      return response.map((json) => CategoryModel.fromJson(json)).toList();
    }

    return [];
  }
}
