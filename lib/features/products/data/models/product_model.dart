import '../../domain/entities/product.dart';
import '../../domain/entities/products_response.dart';

class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.title,
    required super.description,
    required super.category,
    required super.price,
    required super.discountPercentage,
    required super.rating,
    required super.stock,
    required super.tags,
    super.brand,
    super.sku,
    required super.availabilityStatus,
    required super.shippingInformation,
    required super.warrantyInformation,
    required super.returnPolicy,
    required super.images,
    required super.thumbnail,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      discountPercentage:
          (json['discountPercentage'] as num?)?.toDouble() ?? 0.0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      stock: json['stock'] as int? ?? 0,
      tags: (json['tags'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      brand: json['brand'] as String?,
      sku: json['sku'] as String?,
      availabilityStatus: json['availabilityStatus'] as String? ?? '',
      shippingInformation: json['shippingInformation'] as String? ?? '',
      warrantyInformation: json['warrantyInformation'] as String? ?? '',
      returnPolicy: json['returnPolicy'] as String? ?? '',
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      thumbnail: json['thumbnail'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'price': price,
      'discountPercentage': discountPercentage,
      'rating': rating,
      'stock': stock,
      'tags': tags,
      'brand': brand,
      'sku': sku,
      'availabilityStatus': availabilityStatus,
      'shippingInformation': shippingInformation,
      'warrantyInformation': warrantyInformation,
      'returnPolicy': returnPolicy,
      'images': images,
      'thumbnail': thumbnail,
    };
  }
}

class ProductsResponseModel extends ProductsResponse {
  const ProductsResponseModel({
    required super.products,
    required super.total,
    required super.skip,
    required super.limit,
  });

  factory ProductsResponseModel.fromJson(Map<String, dynamic> json) {
    return ProductsResponseModel(
      products: (json['products'] as List<dynamic>)
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int? ?? 0,
      skip: json['skip'] as int? ?? 0,
      limit: json['limit'] as int? ?? 0,
    );
  }
}
