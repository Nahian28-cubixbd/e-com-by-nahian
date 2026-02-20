import 'package:badges/badges.dart' as badges;
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../cart/presentation/cubit/cart_cubit.dart';
import '../../../cart/presentation/pages/cart_page.dart';
import '../../../products/domain/entities/product.dart';
import '../../../products/domain/usecases/get_products_by_category.dart';
import '../../../products/presentation/widgets/error_state_widget.dart';
import '../../../products/presentation/widgets/product_card.dart';
import '../../../products/presentation/widgets/product_shimmer.dart';
import '../../domain/entities/category.dart';

// ─── View Mode ────────────────────────────────────────────────────────────────
enum CategoryViewMode { grid, list }

// ─── States ───────────────────────────────────────────────────────────────────
abstract class CategoryProductsState extends Equatable {
  const CategoryProductsState();
  @override
  List<Object?> get props => [];
}

class CategoryProductsInitial extends CategoryProductsState {}

class CategoryProductsLoading extends CategoryProductsState {}

class CategoryProductsLoaded extends CategoryProductsState {
  final List<Product> products;
  final bool hasMore;
  final bool isLoadingMore;
  final CategoryViewMode viewMode;
  final int total;

  const CategoryProductsLoaded({
    required this.products,
    required this.hasMore,
    this.isLoadingMore = false,
    this.viewMode = CategoryViewMode.list,
    required this.total,
  });

  CategoryProductsLoaded copyWith({
    List<Product>? products,
    bool? hasMore,
    bool? isLoadingMore,
    CategoryViewMode? viewMode,
    int? total,
  }) {
    return CategoryProductsLoaded(
      products: products ?? this.products,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      viewMode: viewMode ?? this.viewMode,
      total: total ?? this.total,
    );
  }

  @override
  List<Object?> get props =>
      [products, hasMore, isLoadingMore, viewMode, total];
}

class CategoryProductsError extends CategoryProductsState {
  final String message;
  const CategoryProductsError(this.message);
  @override
  List<Object?> get props => [message];
}

// ─── Cubit ────────────────────────────────────────────────────────────────────
class CategoryProductsCubit extends Cubit<CategoryProductsState> {
  final GetProductsByCategory getProductsByCategory;
  final String categorySlug;

  int _skip = 0;
  static const _limit = AppConstants.pageSize;

  CategoryProductsCubit({
    required this.getProductsByCategory,
    required this.categorySlug,
  }) : super(CategoryProductsInitial());

  Future<void> fetchProducts({bool refresh = false}) async {
    if (refresh ||
        state is CategoryProductsInitial ||
        state is CategoryProductsError) {
      emit(CategoryProductsLoading());
      _skip = 0;
    }

    final result = await getProductsByCategory(
      GetProductsByCategoryParams(
        category: categorySlug,
        limit: _limit,
        skip: _skip,
      ),
    );

    result.fold(
      (failure) => emit(CategoryProductsError(failure.message)),
      (response) {
        _skip = response.skip + response.limit;
        emit(CategoryProductsLoaded(
          products: response.products,
          hasMore: response.hasMore,
          total: response.total,
        ));
      },
    );
  }

  Future<void> fetchMore() async {
    final current = state;
    if (current is! CategoryProductsLoaded ||
        current.isLoadingMore ||
        !current.hasMore) return;

    emit(current.copyWith(isLoadingMore: true));

    final result = await getProductsByCategory(
      GetProductsByCategoryParams(
        category: categorySlug,
        limit: _limit,
        skip: _skip,
      ),
    );

    result.fold(
      (failure) => emit(current.copyWith(isLoadingMore: false)),
      (response) {
        _skip = response.skip + response.limit;
        emit(current.copyWith(
          products: [...current.products, ...response.products],
          hasMore: response.hasMore,
          isLoadingMore: false,
          total: response.total,
        ));
      },
    );
  }

  void toggleViewMode() {
    final current = state;
    if (current is CategoryProductsLoaded) {
      emit(current.copyWith(
        viewMode: current.viewMode == CategoryViewMode.grid
            ? CategoryViewMode.list
            : CategoryViewMode.grid,
      ));
    }
  }
}

// ─── Page ─────────────────────────────────────────────────────────────────────
class CategoryProductsPage extends StatelessWidget {
  final Category category;

  const CategoryProductsPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CategoryProductsCubit(
        getProductsByCategory: context.read<GetProductsByCategory>(),
        categorySlug: category.slug,
      )..fetchProducts(),
      child: _CategoryProductsView(category: category),
    );
  }
}

class _CategoryProductsView extends StatefulWidget {
  final Category category;
  const _CategoryProductsView({required this.category});

  @override
  State<_CategoryProductsView> createState() => _CategoryProductsViewState();
}

class _CategoryProductsViewState extends State<_CategoryProductsView> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<CategoryProductsCubit>().fetchMore();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(widget.category.name),
        actions: [
          BlocBuilder<CategoryProductsCubit, CategoryProductsState>(
            builder: (context, state) {
              if (state is! CategoryProductsLoaded) return const SizedBox.shrink();
              return IconButton(
                icon: Icon(
                  state.viewMode == CategoryViewMode.grid
                      ? Icons.view_list_rounded
                      : Icons.grid_view_rounded,
                  color: Colors.white,
                ),
                onPressed: () =>
                    context.read<CategoryProductsCubit>().toggleViewMode(),
              );
            },
          ),
          BlocBuilder<CartCubit, CartState>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CartPage()),
                  ),
                  child: badges.Badge(
                    showBadge: state.totalItemCount > 0,
                    badgeContent: Text(
                      state.totalItemCount.toString(),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700),
                    ),
                    badgeStyle: const badges.BadgeStyle(
                      badgeColor: AppColors.accentLight,
                      padding: EdgeInsets.all(5),
                    ),
                    child: const Icon(Icons.shopping_cart_outlined,
                        color: Colors.white, size: 24),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<CategoryProductsCubit, CategoryProductsState>(
        builder: (context, state) {
          if (state is CategoryProductsLoading) {
            return const ProductGridShimmer();
          }
          if (state is CategoryProductsError) {
            return ErrorStateWidget(
              message: state.message,
              onRetry: () => context
                  .read<CategoryProductsCubit>()
                  .fetchProducts(refresh: true),
            );
          }
          if (state is CategoryProductsLoaded) {
            if (state.products.isEmpty) {
              return const Center(
                child: Text(
                  'No products found\nin this category',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16, color: AppColors.textSecondary),
                ),
              );
            }
            return RefreshIndicator(
              color: AppColors.accent,
              onRefresh: () =>
                  context.read<CategoryProductsCubit>().fetchProducts(refresh: true),
              child: state.viewMode == CategoryViewMode.grid
                  ? _buildGrid(state)
                  : _buildList(state),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildGrid(CategoryProductsLoaded state) {
    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.66,
      ),
      itemCount: state.products.length + (state.isLoadingMore ? 2 : 0),
      itemBuilder: (context, index) {
        if (index >= state.products.length) {
          return Container(
            decoration: BoxDecoration(
              color: AppColors.shimmerBase,
              borderRadius: BorderRadius.circular(16),
            ),
          );
        }
        return ProductGridCard(product: state.products[index]);
      },
    );
  }

  Widget _buildList(CategoryProductsLoaded state) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: state.products.length + (state.isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= state.products.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(color: AppColors.accent),
            ),
          );
        }
        return ProductListCard(product: state.products[index]);
      },
    );
  }
}
