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

    // Try to get Arabic name from multiple possible fields
    String categoryName = '';
    if (json['name_ar'] != null && json['name_ar'].toString().isNotEmpty) {
      categoryName = json['name_ar'];
    } else if (json['title_ar'] != null &&
        json['title_ar'].toString().isNotEmpty) {
      categoryName = json['title_ar'];
    } else {
      categoryName = json['name'] ?? '';
    }

    return CategoryModel(
      id: json['id'] ?? 0,
      name: categoryName,
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
    // Try to get Arabic name from multiple possible fields
    String productName = '';

    // Check for Arabic name in various fields
    if (json['name_ar'] != null && json['name_ar'].toString().isNotEmpty) {
      productName = json['name_ar'];
    } else if (json['title_ar'] != null &&
        json['title_ar'].toString().isNotEmpty) {
      productName = json['title_ar'];
    } else if (json['name'] != null) {
      // Check if name contains Arabic characters
      String name = json['name'].toString();
      if (name.contains(RegExp(r'[\u0600-\u06FF]'))) {
        productName = name;
      } else {
        productName = name; // Fallback to any name
      }
    }

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
