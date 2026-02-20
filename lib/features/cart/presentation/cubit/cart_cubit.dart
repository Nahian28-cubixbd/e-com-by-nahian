import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasources/cart_local_data_source.dart';
import '../../domain/entities/cart_item.dart';
import '../../../products/domain/entities/product.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final CartLocalDataSource localDataSource;

  CartCubit(this.localDataSource) : super(const CartState()) {
    _loadCart();
  }

  void _loadCart() {
    try {
      final items = localDataSource.getCartItems();
      emit(CartState(items: items));
    } catch (_) {
      emit(const CartState());
    }
  }

  Future<void> addToCart(Product product) async {
    final currentItems = [...state.items];
    final index =
        currentItems.indexWhere((item) => item.product.id == product.id);

    if (index >= 0) {
      currentItems[index] =
          currentItems[index].copyWith(quantity: currentItems[index].quantity + 1);
    } else {
      currentItems.add(CartItem(product: product, quantity: 1));
    }

    emit(state.copyWith(items: currentItems));
    await _saveCart(currentItems);
  }

  Future<void> removeFromCart(int productId) async {
    final currentItems =
        state.items.where((item) => item.product.id != productId).toList();
    emit(state.copyWith(items: currentItems));
    await _saveCart(currentItems);
  }

  Future<void> decreaseQuantity(int productId) async {
    final currentItems = [...state.items];
    final index =
        currentItems.indexWhere((item) => item.product.id == productId);

    if (index >= 0) {
      if (currentItems[index].quantity <= 1) {
        currentItems.removeAt(index);
      } else {
        currentItems[index] = currentItems[index]
            .copyWith(quantity: currentItems[index].quantity - 1);
      }
    }

    emit(state.copyWith(items: currentItems));
    await _saveCart(currentItems);
  }

  Future<void> clearCart() async {
    emit(const CartState());
    await localDataSource.clearCart();
  }

  bool isInCart(int productId) {
    return state.items.any((item) => item.product.id == productId);
  }

  int getItemQuantity(int productId) {
    final item =
        state.items.where((item) => item.product.id == productId).firstOrNull;
    return item?.quantity ?? 0;
  }

  Future<void> _saveCart(List<CartItem> items) async {
    try {
      await localDataSource.saveCartItems(items);
    } catch (_) {}
  }
}
