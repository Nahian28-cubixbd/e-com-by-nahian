import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/usecases/get_products.dart';
import '../../domain/usecases/get_products_by_category.dart';
import 'products_event.dart';
import 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final GetProducts getProducts;
  final GetProductsByCategory? getProductsByCategory;
  final String? category;

  int _currentSkip = 0;
  static const _limit = AppConstants.pageSize;

  ProductsBloc({
    required this.getProducts,
    this.getProductsByCategory,
    this.category,
  }) : super(const ProductsInitial()) {
    on<FetchProductsEvent>(_onFetchProducts);
    on<FetchMoreProductsEvent>(_onFetchMore);
    on<ToggleViewModeEvent>(_onToggleViewMode);
  }

  Future<void> _onFetchProducts(
      FetchProductsEvent event, Emitter<ProductsState> emit) async {
    if (event.isRefresh || state is ProductsInitial || state is ProductsError) {
      emit(const ProductsLoading());
      _currentSkip = 0;
    }

    final params = GetProductsParams(limit: _limit, skip: _currentSkip);
    final result = await getProducts(params);

    result.fold(
      (failure) => emit(ProductsError(failure.message)),
      (response) {
        _currentSkip = response.skip + response.limit;
        emit(ProductsLoaded(
          products: response.products,
          hasMore: response.hasMore,
          total: response.total,
        ));
      },
    );
  }

  Future<void> _onFetchMore(
      FetchMoreProductsEvent event, Emitter<ProductsState> emit) async {
    final current = state;
    if (current is! ProductsLoaded || current.isLoadingMore || !current.hasMore)
      return;

    emit(current.copyWith(isLoadingMore: true));

    final params = GetProductsParams(limit: _limit, skip: _currentSkip);
    final result = await getProducts(params);

    result.fold(
      (failure) => emit(current.copyWith(isLoadingMore: false)),
      (response) {
        _currentSkip = response.skip + response.limit;
        emit(current.copyWith(
          products: [...current.products, ...response.products],
          hasMore: response.hasMore,
          isLoadingMore: false,
          total: response.total,
        ));
      },
    );
  }

  void _onToggleViewMode(
      ToggleViewModeEvent event, Emitter<ProductsState> emit) {
    final current = state;
    if (current is ProductsLoaded) {
      emit(current.copyWith(
        viewMode: current.viewMode == ViewMode.grid ? ViewMode.list : ViewMode.grid,
      ));
    }
  }
}
