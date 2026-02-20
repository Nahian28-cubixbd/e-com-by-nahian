import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:e_com_by_nahian/core/constants/app_constants.dart';
import 'package:e_com_by_nahian/core/network/dio_client.dart';
import 'package:e_com_by_nahian/core/network/network_info.dart';
import 'package:e_com_by_nahian/features/cart/data/datasources/cart_local_data_source.dart';
import 'package:e_com_by_nahian/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:e_com_by_nahian/features/categories/data/datasources/category_remote_data_source.dart';
import 'package:e_com_by_nahian/features/categories/data/repositories/category_repository_impl.dart';
import 'package:e_com_by_nahian/features/categories/domain/repositories/category_repository.dart';
import 'package:e_com_by_nahian/features/categories/domain/usecases/get_categories.dart';
import 'package:e_com_by_nahian/features/categories/presentation/cubit/categories_cubit.dart';
import 'package:e_com_by_nahian/features/products/data/datasources/product_remote_data_source.dart';
import 'package:e_com_by_nahian/features/products/data/repositories/product_repository_impl.dart';
import 'package:e_com_by_nahian/features/products/domain/repositories/product_repository.dart';
import 'package:e_com_by_nahian/features/products/domain/usecases/get_products.dart';
import 'package:e_com_by_nahian/features/products/domain/usecases/get_products_by_category.dart';
import 'package:e_com_by_nahian/features/products/presentation/bloc/products_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // ── External ──────────────────────────────────
  sl.registerLazySingleton(() => DioClient.instance);
  sl.registerLazySingleton(() => Connectivity());

  // ── Core ──────────────────────────────────────
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(sl()),
  );

  // ── Hive Cart Box ─────────────────────────────
  final cartBox = await Hive.openBox(AppConstants.cartBox);
  sl.registerSingleton(cartBox);

  // ── Cart ──────────────────────────────────────
  sl.registerLazySingleton<CartLocalDataSource>(
    () => CartLocalDataSourceImpl(sl()),
  );
  sl.registerFactory(() => CartCubit(sl()));

  // ── Products ──────────────────────────────────
  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  sl.registerLazySingleton(() => GetProducts(sl()));
  sl.registerLazySingleton(() => GetProductsByCategory(sl()));
  sl.registerFactory(
    () => ProductsBloc(
      getProducts: sl(),
      getProductsByCategory: sl(),
    ),
  );

  // ── Categories ────────────────────────────────
  sl.registerLazySingleton<CategoryRemoteDataSource>(
    () => CategoryRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  sl.registerLazySingleton(() => GetCategories(sl()));
  sl.registerFactory(() => CategoriesCubit(sl()));
}
