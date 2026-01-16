import 'package:equatable/equatable.dart';

class ProductDetails extends Equatable {
  final int id;
  final String name; // English name (name_en)
  final String? nameAr; // Arabic name (name_ar)
  final String? description; // English description
  final String? descriptionAr; // Arabic description
  final String? shortDescription;
  final String price;
  final int? priceTax;
  final int? priceTaxSale;
  final String? regularPrice;
  final String? salePrice;
  final bool onSale;
  final List<String> images;
  final List<ProductAddon> addons;
  final int points;
  final int totalSales;

  const ProductDetails({
    required this.id,
    required this.name,
    this.nameAr,
    this.description,
    this.descriptionAr,
    this.shortDescription,
    required this.price,
    this.priceTax,
    this.priceTaxSale,
    this.regularPrice,
    this.salePrice,
    this.onSale = false,
    this.images = const [],
    this.addons = const [],
    this.points = 0,
    this.totalSales = 0,
  });

  /// Get localized name based on language code
  String getLocalizedName(String languageCode) {
    if (languageCode == 'ar' && nameAr != null && nameAr!.isNotEmpty) {
      return nameAr!;
    }
    return name; // Default to English name
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

  /// Get display price (prefer price_tax as integer)
  String get displayPrice {
    if (priceTax != null && priceTax! > 0) {
      return priceTax.toString();
    }
    final priceValue = double.tryParse(price);
    if (priceValue != null) {
      return priceValue.toInt().toString();
    }
    return price;
  }

  /// Create a copy with addons
  ProductDetails copyWithAddons(List<ProductAddon> newAddons) {
    return ProductDetails(
      id: id,
      name: name,
      nameAr: nameAr,
      description: description,
      descriptionAr: descriptionAr,
      shortDescription: shortDescription,
      price: price,
      priceTax: priceTax,
      priceTaxSale: priceTaxSale,
      regularPrice: regularPrice,
      salePrice: salePrice,
      onSale: onSale,
      images: images,
      addons: newAddons,
      points: points,
      totalSales: totalSales,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    nameAr,
    description,
    descriptionAr,
    shortDescription,
    price,
    priceTax,
    priceTaxSale,
    regularPrice,
    salePrice,
    onSale,
    images,
    addons,
    points,
    totalSales,
  ];
}

class ProductAddon extends Equatable {
  final String id;
  final String name; // English name (title)
  final String? nameAr; // Arabic name (title_ar)
  final String price;
  final bool isRequired;
  final bool isMultiChoice;
  final List<AddonOption> options;

  const ProductAddon({
    required this.id,
    required this.name,
    this.nameAr,
    this.price = '0',
    this.isRequired = false,
    this.isMultiChoice = false,
    this.options = const [],
  });

  /// Get localized name based on language code
  String getLocalizedName(String languageCode) {
    if (languageCode == 'ar' && nameAr != null && nameAr!.isNotEmpty) {
      return nameAr!;
    }
    return name; // Default to English name
  }

  @override
  List<Object?> get props => [
    id,
    name,
    nameAr,
    price,
    isRequired,
    isMultiChoice,
    options,
  ];
}

class AddonOption extends Equatable {
  final String label; // English label
  final String? labelAr; // Arabic label
  final String price;
  final bool isSelectedByDefault;
  final bool isEnabled;

  const AddonOption({
    required this.label,
    this.labelAr,
    this.price = '0',
    this.isSelectedByDefault = false,
    this.isEnabled = true,
  });

  /// Get localized label based on language code
  String getLocalizedLabel(String languageCode) {
    if (languageCode == 'ar' && labelAr != null && labelAr!.isNotEmpty) {
      return labelAr!;
    }
    return label; // Default to English label
  }

  AddonOption copyWith({bool? isSelected}) {
    return AddonOption(
      label: label,
      labelAr: labelAr,
      price: price,
      isSelectedByDefault: isSelected ?? isSelectedByDefault,
      isEnabled: isEnabled,
    );
  }

  @override
  List<Object?> get props => [
    label,
    labelAr,
    price,
    isSelectedByDefault,
    isEnabled,
  ];
}
