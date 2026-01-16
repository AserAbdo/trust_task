import '../../domain/entities/category.dart';

class CategoryModel extends Category {
  const CategoryModel({
    required super.id,
    required super.name,
    super.image,
    super.description,
    super.count,
    super.products,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    List<Product> products = [];
    if (json['products'] != null) {
      products = (json['products'] as List)
          .map((p) => ProductModel.fromJson(p))
          .toList();
    }

    return CategoryModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      image: json['image'],
      description: json['description'],
      count: json['count'] ?? 0,
      products: products,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'description': description,
      'count': count,
    };
  }
}

class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.name,
    super.description,
    super.image,
    required super.price,
    super.regularPrice,
    super.salePrice,
    super.onSale,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    // Use Arabic name if available, fallback to regular name
    String productName = json['name_ar'] ?? json['name'] ?? '';

    return ProductModel(
      id: json['id'] ?? 0,
      name: productName,
      description: json['description'] ?? json['short_description'] ?? '',
      image: _extractImage(json),
      price: json['price']?.toString() ?? '0',
      regularPrice: json['regular_price']?.toString(),
      salePrice: json['sale_price']?.toString(),
      onSale: json['on_sale'] ?? false,
    );
  }

  static String? _extractImage(Map<String, dynamic> json) {
    if (json['image'] != null && json['image'].toString().isNotEmpty) {
      return json['image'];
    }
    if (json['images'] != null && (json['images'] as List).isNotEmpty) {
      final firstImage = json['images'][0];
      if (firstImage is String) return firstImage;
      if (firstImage is Map) return firstImage['src'];
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image': image,
      'price': price,
      'regular_price': regularPrice,
      'sale_price': salePrice,
      'on_sale': onSale,
    };
  }
}
