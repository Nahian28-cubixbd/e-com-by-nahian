import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/products_response.dart';

abstract class ProductRepository {
  Future<Either<Failure, ProductsResponse>> getProducts({
    required int limit,
    required int skip,
  });

  Future<Either<Failure, ProductsResponse>> getProductsByCategory({
    required String category,
    required int limit,
    required int skip,
  });
}
