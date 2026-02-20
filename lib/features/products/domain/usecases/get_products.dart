import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/usecase.dart';
import '../entities/products_response.dart';
import '../repositories/product_repository.dart';

class GetProducts extends UseCase<ProductsResponse, GetProductsParams> {
  final ProductRepository repository;

  GetProducts(this.repository);

  @override
  Future<Either<Failure, ProductsResponse>> call(
      GetProductsParams params) async {
    return await repository.getProducts(
      limit: params.limit,
      skip: params.skip,
    );
  }
}

class GetProductsParams extends Equatable {
  final int limit;
  final int skip;

  const GetProductsParams({required this.limit, required this.skip});

  @override
  List<Object?> get props => [limit, skip];
}
