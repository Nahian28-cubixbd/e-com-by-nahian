import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final int id;
  final String title;
  final String description;
  final String category;
  final double price;
  final double discountPercentage;
  final double rating;
  final int stock;
  final List<String> tags;
  final String? brand;
  final String? sku;
  final String availabilityStatus;
  final String shippingInformation;
  final String warrantyInformation;
  final String returnPolicy;
  final List<String> images;
  final String thumbnail;

  const Product({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    required this.tags,
    this.brand,
    this.sku,
    required this.availabilityStatus,
    required this.shippingInformation,
    required this.warrantyInformation,
    required this.returnPolicy,
    required this.images,
    required this.thumbnail,
  });

  double get discountedPrice =>
      price - (price * discountPercentage / 100);

  bool get isInStock => stock > 0;

  @override
  List<Object?> get props => [id, title, price, category];
}
