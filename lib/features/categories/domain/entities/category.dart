import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final int id;
  final String name;
  final String? nameEn;
  final String? image;
  final String? description;
  final int count;
  final List<Product> products;

  const Category({
    required this.id,
    required this.name,
    this.nameEn,
    this.image,
    this.description,
    this.count = 0,
    this.products = const [],
  });

  /// Get localized name based on language code
  String getLocalizedName(String languageCode) {
    if (languageCode == 'en' && nameEn != null && nameEn!.isNotEmpty) {
      return nameEn!;
    }
    return name;
  }

  @override
  List<Object?> get props => [
    id,
    name,
    nameEn,
    image,
    description,
    count,
    products,
  ];
}

class Product extends Equatable {
  final int id;
  final String name; // Arabic name (name_ar)
  final String? nameEn; // English name (name_en)
  final String? description; // English description
  final String? descriptionAr; // Arabic description
  final String? image;
  final String price;
  final int? priceTax;
  final String? regularPrice;
  final String? salePrice;
  final bool onSale;
  final int points;
  final int totalSales;

  const Product({
    required this.id,
    required this.name,
    this.nameEn,
    this.description,
    this.descriptionAr,
    this.image,
    required this.price,
    this.priceTax,
    this.regularPrice,
    this.salePrice,
    this.onSale = false,
    this.points = 0,
    this.totalSales = 0,
  });

  /// Get localized name based on language code
  String getLocalizedName(String languageCode) {
    if (languageCode == 'en' && nameEn != null && nameEn!.isNotEmpty) {
      return nameEn!;
    }
    return name; // Default to Arabic name
  }

  /// Get localized description based on language code
  String getLocalizedDescription(String languageCode) {
    if (languageCode == 'ar' &&
        descriptionAr != null &&
        descriptionAr!.isNotEmpty) {
      return descriptionAr!;
    }
    return description ?? '';
  }

  /// Get the display price (prefer price_tax as integer)
  String get displayPrice {
    if (priceTax != null && priceTax! > 0) {
      return priceTax.toString();
    }
    // Remove decimals from price string
    final priceValue = double.tryParse(price);
    if (priceValue != null) {
      return priceValue.toInt().toString();
    }
    return price;
  }

  @override
  List<Object?> get props => [
    id,
    name,
    nameEn,
    description,
    descriptionAr,
    image,
    price,
    priceTax,
    regularPrice,
    salePrice,
    onSale,
    points,
    totalSales,
  ];
}
