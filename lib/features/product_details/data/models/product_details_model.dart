import '../../domain/entities/product_details.dart';

class ProductDetailsModel extends ProductDetails {
  const ProductDetailsModel({
    required super.id,
    required super.name,
    super.nameAr,
    super.description,
    super.descriptionAr,
    super.shortDescription,
    required super.price,
    super.priceTax,
    super.priceTaxSale,
    super.regularPrice,
    super.salePrice,
    super.onSale,
    super.images,
    super.addons,
    super.points,
    super.totalSales,
  });

  factory ProductDetailsModel.fromJson(Map<String, dynamic> json) {
    // Extract images
    List<String> imagesList = [];
    if (json['image'] != null && json['image'].toString().isNotEmpty) {
      imagesList.add(json['image'].toString());
    }
    if (json['images'] != null) {
      final imgs = (json['images'] as List)
          .map((img) => img is String ? img : img['src']?.toString() ?? '')
          .where((url) => url.isNotEmpty)
          .toList();
      imagesList.addAll(imgs);
    }

    // Parse price_tax
    int? priceTax;
    if (json['price_tax'] != null) {
      priceTax = (json['price_tax'] is int)
          ? json['price_tax']
          : int.tryParse(json['price_tax'].toString());
    }

    int? priceTaxSale;
    if (json['price_tax_sale'] != null) {
      priceTaxSale = (json['price_tax_sale'] is int)
          ? json['price_tax_sale']
          : int.tryParse(json['price_tax_sale'].toString());
    }

    return ProductDetailsModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      nameAr: json['name_ar'],
      description: _stripHtml(
        json['description_en'] ?? json['description'] ?? '',
      ),
      descriptionAr: _stripHtml(json['description_ar'] ?? ''),
      shortDescription: _stripHtml(json['short_description'] ?? ''),
      price: json['price']?.toString() ?? '0',
      priceTax: priceTax,
      priceTaxSale: priceTaxSale,
      regularPrice: json['regular_price']?.toString(),
      salePrice: json['sale_price']?.toString(),
      onSale: json['on_sale'] ?? false,
      images: imagesList,
      points: json['points'] ?? 0,
      totalSales: json['total_sales'] ?? 0,
    );
  }

  static String _stripHtml(String htmlString) {
    final RegExp exp = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);
    return htmlString.replaceAll(exp, '').trim();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'name_ar': nameAr,
      'description': description,
      'description_ar': descriptionAr,
      'short_description': shortDescription,
      'price': price,
      'price_tax': priceTax,
      'price_tax_sale': priceTaxSale,
      'regular_price': regularPrice,
      'sale_price': salePrice,
      'on_sale': onSale,
      'images': images,
      'points': points,
      'total_sales': totalSales,
    };
  }
}

/// Parse addons from the proaddon API response
class ProductAddonsResponse {
  final List<ProductAddon> addons;

  ProductAddonsResponse({required this.addons});

  factory ProductAddonsResponse.fromJson(Map<String, dynamic> json) {
    List<ProductAddon> allAddons = [];

    // Parse blocks -> addons
    if (json['blocks'] != null) {
      for (var block in json['blocks'] as List) {
        if (block['addons'] != null) {
          for (var addon in block['addons'] as List) {
            allAddons.add(ProductAddonModel.fromJson(addon));
          }
        }
      }
    }

    return ProductAddonsResponse(addons: allAddons);
  }
}

class ProductAddonModel extends ProductAddon {
  const ProductAddonModel({
    required super.id,
    required super.name,
    super.nameAr,
    super.price,
    super.isRequired,
    super.isMultiChoice,
    super.options,
  });

  factory ProductAddonModel.fromJson(Map<String, dynamic> json) {
    List<AddonOption> optionsList = [];
    if (json['options'] != null) {
      optionsList = (json['options'] as List)
          .where((opt) => opt['addon_enabled'] == true)
          .map((opt) => AddonOptionModel.fromJson(opt))
          .toList();
    }

    return ProductAddonModel(
      id: json['id']?.toString() ?? '',
      name: json['title'] ?? json['name'] ?? '',
      nameAr: json['title_ar'] ?? json['name_ar'],
      price: json['price']?.toString() ?? '0',
      isRequired: json['required'] == true || json['required'] == 1,
      isMultiChoice:
          json['IsMultiChoise'] == true || json['IsMultiChoise'] == 1,
      options: optionsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'name_ar': nameAr,
      'price': price,
      'required': isRequired,
      'IsMultiChoise': isMultiChoice,
      'options': options
          .map(
            (o) => {'label': o.label, 'label_ar': o.labelAr, 'price': o.price},
          )
          .toList(),
    };
  }
}

class AddonOptionModel extends AddonOption {
  const AddonOptionModel({
    required super.label,
    super.labelAr,
    super.price,
    super.isSelectedByDefault,
    super.isEnabled,
  });

  factory AddonOptionModel.fromJson(Map<String, dynamic> json) {
    // Parse price - handle empty string and "free" price_method
    String price = '0';
    if (json['price'] != null && json['price'].toString().isNotEmpty) {
      price = json['price'].toString();
    }
    // If price_method is "free", price is 0
    if (json['price_method'] == 'free') {
      price = '0';
    }

    return AddonOptionModel(
      label: json['label'] ?? json['name'] ?? '',
      labelAr: json['label_ar'] ?? json['name_ar'],
      price: price,
      isSelectedByDefault: json['selected_by_default'] == true,
      isEnabled: json['addon_enabled'] == true,
    );
  }
}
