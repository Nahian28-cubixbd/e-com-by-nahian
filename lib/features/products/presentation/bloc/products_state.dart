import 'package:equatable/equatable.dart';
import '../../domain/entities/product.dart';

enum ViewMode { grid, list }

abstract class ProductsState extends Equatable {
  const ProductsState();

  @override
  List<Object?> get props => [];
}

class ProductsInitial extends ProductsState {
  const ProductsInitial();
}

class ProductsLoading extends ProductsState {
  const ProductsLoading();
}

class ProductsLoaded extends ProductsState {
  final List<Product> products;
  final bool hasMore;
  final bool isLoadingMore;
  final ViewMode viewMode;
  final int total;

  const ProductsLoaded({
    required this.products,
    required this.hasMore,
    this.isLoadingMore = false,
    this.viewMode = ViewMode.list,
    required this.total,
  });

  ProductsLoaded copyWith({
    List<Product>? products,
    bool? hasMore,
    bool? isLoadingMore,
    ViewMode? viewMode,
    int? total,
  }) {
    return ProductsLoaded(
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

class ProductsError extends ProductsState {
  final String message;

  const ProductsError(this.message);

  @override
  List<Object?> get props => [message];
}
