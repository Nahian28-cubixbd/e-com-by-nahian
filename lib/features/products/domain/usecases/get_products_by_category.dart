import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/usecase.dart';
import '../entities/products_response.dart';
import '../repositories/product_repository.dart';

class GetProductsByCategory
    extends UseCase<ProductsResponse, GetProductsByCategoryParams> {
  final ProductRepository repository;

  GetProductsByCategory(this.repository);

  @override
  Future<Either<Failure, ProductsResponse>> call(
      GetProductsByCategoryParams params) async {
    return await repository.getProductsByCategory(
      category: params.category,
      limit: params.limit,
      skip: params.skip,
    );
  }
}

class GetProductsByCategoryParams extends Equatable {
  final String category;
  final int limit;
  final int skip;

  const GetProductsByCategoryParams({
    required this.category,
    required this.limit,
    required this.skip,
  });

  @override
  List<Object?> get props => [category, limit, skip];
}
