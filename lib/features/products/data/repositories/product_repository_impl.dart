import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/products_response.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_data_source.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, ProductsResponse>> getProducts({
    required int limit,
    required int skip,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(
          NetworkFailure('No internet connection. Please check your network.'));
    }
    try {
      final result =
          await remoteDataSource.getProducts(limit: limit, skip: skip);
      return Right(result);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProductsResponse>> getProductsByCategory({
    required String category,
    required int limit,
    required int skip,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(
          NetworkFailure('No internet connection. Please check your network.'));
    }
    try {
      final result = await remoteDataSource.getProductsByCategory(
          category: category, limit: limit, skip: skip);
      return Right(result);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
