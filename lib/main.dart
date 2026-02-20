import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/theme/app_theme.dart';
import 'features/cart/presentation/cubit/cart_cubit.dart';
import 'features/categories/presentation/cubit/categories_cubit.dart';
import 'features/products/domain/usecases/get_products.dart';
import 'features/products/domain/usecases/get_products_by_category.dart';
import 'features/products/presentation/bloc/products_bloc.dart';
import 'features/products/presentation/pages/home_page.dart';
import 'injection/injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock orientation to portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Transparent status bar
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));

  // Init Hive
  await Hive.initFlutter();

  // Init dependencies
  await initDependencies();

  // Init Firebase & Push Notifications
  // NOTE: To enable FCM, add google-services.json / GoogleService-Info.plist
  // and uncomment the firebase_core + firebase_messaging dependencies in pubspec.yaml

  runApp(const ShopEaseApp());
}

class ShopEaseApp extends StatelessWidget {
  const ShopEaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // CartCubit is app-wide (shared across all pages)
        BlocProvider<CartCubit>(
          create: (_) => sl<CartCubit>(),
        ),
        // CategoriesCubit is app-wide
        BlocProvider<CategoriesCubit>(
          create: (_) => sl<CategoriesCubit>(),
        ),
        // ProductsBloc is app-wide for AllProductsPage
        BlocProvider<ProductsBloc>(
          create: (_) => sl<ProductsBloc>(),
        ),
        // Provide use cases for CategoryProductsPage to create its own bloc
        RepositoryProvider<GetProducts>(
          create: (_) => sl<GetProducts>(),
        ),
        RepositoryProvider<GetProductsByCategory>(
          create: (_) => sl<GetProductsByCategory>(),
        ),
      ],
      child: MaterialApp(
        title: 'E-Com by Nahian',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const HomePage(),
      ),
    );
  }
}
