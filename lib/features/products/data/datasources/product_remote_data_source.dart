import 'package:dio/dio.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<ProductsResponseModel> getProducts({
    required int limit,
    required int skip,
  });

  Future<ProductsResponseModel> getProductsByCategory({
    required String category,
    required int limit,
    required int skip,
  });
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final Dio dio;

  ProductRemoteDataSourceImpl(this.dio);

  @override
  Future<ProductsResponseModel> getProducts({
    required int limit,
    required int skip,
  }) async {
    try {
      final response = await dio.get(
        AppConstants.productsEndpoint,
        queryParameters: {'limit': limit, 'skip': skip},
      );
      if (response.statusCode == 200) {
        return ProductsResponseModel.fromJson(
            response.data as Map<String, dynamic>);
      }
      throw ServerException('Failed to fetch products: ${response.statusCode}');
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw NetworkException('Connection timeout. Please check your internet.');
      }
      if (e.response?.statusCode == 404) {
        throw ServerException('Products not found.');
      }
      throw ServerException(e.message ?? 'Server error occurred.');
    }
  }

  @override
  Future<ProductsResponseModel> getProductsByCategory({
    required String category,
    required int limit,
    required int skip,
  }) async {
    try {
      final response = await dio.get(
        '${AppConstants.productsByCategoryEndpoint}/$category',
        queryParameters: {'limit': limit, 'skip': skip},
      );
      if (response.statusCode == 200) {
        return ProductsResponseModel.fromJson(
            response.data as Map<String, dynamic>);
      }
      throw ServerException(
          'Failed to fetch products by category: ${response.statusCode}');
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw NetworkException('Connection timeout. Please check your internet.');
      }
      throw ServerException(e.message ?? 'Server error occurred.');
    }
  }
}
