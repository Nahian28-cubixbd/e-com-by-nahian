import 'dart:convert';
import 'package:hive/hive.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../products/data/models/product_model.dart';
import '../../domain/entities/cart_item.dart';

abstract class CartLocalDataSource {
  List<CartItem> getCartItems();
  Future<void> saveCartItems(List<CartItem> items);
  Future<void> clearCart();
}

class CartLocalDataSourceImpl implements CartLocalDataSource {
  final Box box;

  CartLocalDataSourceImpl(this.box);

  @override
  List<CartItem> getCartItems() {
    try {
      final data = box.get(AppConstants.cartItemsKey);
      if (data == null) return [];
      final List<dynamic> jsonList = jsonDecode(data as String);
      return jsonList.map((item) {
        final productJson = item['product'] as Map<String, dynamic>;
        final product = ProductModel.fromJson(productJson);
        return CartItem(
          product: product,
          quantity: item['quantity'] as int,
        );
      }).toList();
    } catch (e) {
      throw CacheException('Failed to load cart: $e');
    }
  }

  @override
  Future<void> saveCartItems(List<CartItem> items) async {
    try {
      final jsonList = items
          .map((item) => {
                'product': (item.product as ProductModel).toJson(),
                'quantity': item.quantity,
              })
          .toList();
      await box.put(AppConstants.cartItemsKey, jsonEncode(jsonList));
    } catch (e) {
      throw CacheException('Failed to save cart: $e');
    }
  }

  @override
  Future<void> clearCart() async {
    await box.delete(AppConstants.cartItemsKey);
  }
}
