import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../cart/presentation/cubit/cart_cubit.dart';
import '../../../cart/presentation/pages/cart_page.dart';
import '../bloc/products_bloc.dart';
import '../bloc/products_event.dart';
import '../bloc/products_state.dart';
import '../widgets/error_state_widget.dart';
import '../widgets/product_card.dart';
import '../widgets/product_shimmer.dart';
import '../../../../core/theme/app_theme.dart';

class AllProductsPage extends StatefulWidget {
  const AllProductsPage({super.key});

  @override
  State<AllProductsPage> createState() => _AllProductsPageState();
}

class _AllProductsPageState extends State<AllProductsPage> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<ProductsBloc>().add(const FetchProductsEvent());
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<ProductsBloc>().add(const FetchMoreProductsEvent());
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
        title: BlocBuilder<ProductsBloc, ProductsState>(
          builder: (context, state) {
            final total =
                state is ProductsLoaded ? ' (${state.total})' : '';
            return Text('All Products$total');
          },
        ),
        actions: [
          BlocBuilder<ProductsBloc, ProductsState>(
            builder: (context, state) {
              if (state is! ProductsLoaded) return const SizedBox.shrink();
              return IconButton(
                icon: Icon(
                  state.viewMode == ViewMode.grid
                      ? Icons.view_list_rounded
                      : Icons.grid_view_rounded,
                  color: Colors.white,
                ),
                onPressed: () =>
                    context.read<ProductsBloc>().add(const ToggleViewModeEvent()),
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
      body: BlocBuilder<ProductsBloc, ProductsState>(
        builder: (context, state) {
          if (state is ProductsLoading) {
            return const ProductGridShimmer();
          }
          if (state is ProductsError) {
            return ErrorStateWidget(
              message: state.message,
              onRetry: () => context
                  .read<ProductsBloc>()
                  .add(const FetchProductsEvent(isRefresh: true)),
            );
          }
          if (state is ProductsLoaded) {
            return RefreshIndicator(
              color: AppColors.accent,
              onRefresh: () async {
                context
                    .read<ProductsBloc>()
                    .add(const FetchProductsEvent(isRefresh: true));
              },
              child: state.viewMode == ViewMode.grid
                  ? _buildGrid(state)
                  : _buildList(state),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildGrid(ProductsLoaded state) {
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
          return _ShimmerGridItem();
        }
        return ProductGridCard(product: state.products[index]);
      },
    );
  }

  Widget _buildList(ProductsLoaded state) {
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

class _ShimmerGridItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.shimmerBase,
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}
