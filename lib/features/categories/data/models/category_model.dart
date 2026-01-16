import '../../domain/entities/category.dart';

class CategoryModel extends Category {
  const CategoryModel({
    required super.id,
    required super.name,
    super.nameEn,
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

    // Get Arabic name (priority) and English name
    String categoryName = json['name_ar'] ?? json['name'] ?? '';
    String? categoryNameEn = json['name_en'];

    return CategoryModel(
      id: json['id'] ?? 0,
      name: categoryName,
      nameEn: categoryNameEn,
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
      'name_en': nameEn,
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
    super.nameEn,
    super.description,
    super.descriptionAr,
    super.image,
    required super.price,
    super.priceTax,
    super.regularPrice,
    super.salePrice,
    super.onSale,
    super.points,
    super.totalSales,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    // Get Arabic name (priority)
    String productName = json['name_ar'] ?? json['name'] ?? '';
    String? productNameEn = json['name_en'];

    // Get Arabic description
    String? descriptionAr = json['description_ar'];
    String? descriptionEn = json['description_en'] ?? json['description'];

    // Parse price_tax as integer
    int? priceTax;
    if (json['price_tax'] != null) {
      priceTax = (json['price_tax'] is int)
          ? json['price_tax']
          : int.tryParse(json['price_tax'].toString());
    }

    return ProductModel(
      id: json['id'] ?? 0,
      name: productName,
      nameEn: productNameEn,
      description: descriptionEn,
      descriptionAr: descriptionAr,
      image: _extractImage(json),
      price: json['price']?.toString() ?? '0',
      priceTax: priceTax,
      regularPrice: json['regular_price']?.toString(),
      salePrice: json['sale_price']?.toString(),
      onSale: json['on_sale'] ?? false,
      points: json['points'] ?? 0,
      totalSales: json['total_sales'] ?? 0,
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
      'name_en': nameEn,
      'description': description,
      'description_ar': descriptionAr,
      'image': image,
      'price': price,
      'price_tax': priceTax,
      'regular_price': regularPrice,
      'sale_price': salePrice,
      'on_sale': onSale,
      'points': points,
      'total_sales': totalSales,
    };
  }
}
