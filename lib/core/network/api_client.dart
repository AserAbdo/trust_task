import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import '../error/exceptions.dart';

class ApiClient {
  final Dio _dio;

  ApiClient({Dio? dio}) : _dio = dio ?? Dio() {
    _dio.options = BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Authorization': ApiConstants.authHeader,
        'Content-Type': 'application/json',
      },
    );

    _dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true),
    );
  }

  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<dynamic> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<dynamic> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  ServerException _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ServerException(
          message: 'Connection timeout. Please try again.',
          statusCode: e.response?.statusCode,
        );
      case DioExceptionType.badResponse:
        return ServerException(
          message: e.response?.data?['message'] ?? 'Server error occurred',
          statusCode: e.response?.statusCode,
        );
      case DioExceptionType.connectionError:
        return ServerException(
          message: 'No internet connection',
          statusCode: null,
        );
      default:
        return ServerException(
          message: e.message ?? 'An unexpected error occurred',
          statusCode: e.response?.statusCode,
        );
    }
  }
}
