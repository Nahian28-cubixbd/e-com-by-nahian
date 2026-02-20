import 'package:equatable/equatable.dart';

abstract class ProductsEvent extends Equatable {
  const ProductsEvent();

  @override
  List<Object?> get props => [];
}

class FetchProductsEvent extends ProductsEvent {
  final bool isRefresh;

  const FetchProductsEvent({this.isRefresh = false});

  @override
  List<Object?> get props => [isRefresh];
}

class FetchMoreProductsEvent extends ProductsEvent {
  const FetchMoreProductsEvent();
}

class ToggleViewModeEvent extends ProductsEvent {
  const ToggleViewModeEvent();
}
