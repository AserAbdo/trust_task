import '../../domain/entities/product_details.dart';

class ProductDetailsModel extends ProductDetails {
  const ProductDetailsModel({
    required super.id,
    required super.name,
    super.description,
    super.shortDescription,
    required super.price,
    super.regularPrice,
    super.salePrice,
    super.onSale,
    super.images,
    super.addons,
  });

  factory ProductDetailsModel.fromJson(Map<String, dynamic> json) {
    List<String> imagesList = [];
    if (json['images'] != null) {
      imagesList = (json['images'] as List)
          .map((img) => img is String ? img : img['src']?.toString() ?? '')
          .where((url) => url.isNotEmpty)
          .toList();
    }
    if (json['image'] != null && json['image'].toString().isNotEmpty) {
      imagesList.insert(0, json['image'].toString());
    }

    return ProductDetailsModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: _stripHtml(json['description'] ?? ''),
      shortDescription: _stripHtml(json['short_description'] ?? ''),
      price: json['price']?.toString() ?? '0',
      regularPrice: json['regular_price']?.toString(),
      salePrice: json['sale_price']?.toString(),
      onSale: json['on_sale'] ?? false,
      images: imagesList,
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
      'description': description,
      'short_description': shortDescription,
      'price': price,
      'regular_price': regularPrice,
      'sale_price': salePrice,
      'on_sale': onSale,
      'images': images,
    };
  }
}

class ProductAddonModel extends ProductAddon {
  const ProductAddonModel({
    required super.id,
    required super.name,
    required super.price,
    super.type,
    super.options,
  });

  factory ProductAddonModel.fromJson(Map<String, dynamic> json) {
    List<AddonOption> optionsList = [];
    if (json['options'] != null) {
      optionsList = (json['options'] as List)
          .map((opt) => AddonOptionModel.fromJson(opt))
          .toList();
    }

    return ProductAddonModel(
      id: json['id'] ?? json['addon_id'] ?? 0,
      name: json['name'] ?? json['addon_name'] ?? '',
      price:
          json['price']?.toString() ?? json['addon_price']?.toString() ?? '0',
      type: json['type'] ?? json['addon_type'] ?? 'checkbox',
      options: optionsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'type': type,
      'options': options
          .map((o) => {'label': o.label, 'price': o.price})
          .toList(),
    };
  }
}

class AddonOptionModel extends AddonOption {
  const AddonOptionModel({
    required super.label,
    required super.price,
    super.isSelected,
  });

  factory AddonOptionModel.fromJson(Map<String, dynamic> json) {
    return AddonOptionModel(
      label: json['label'] ?? json['name'] ?? '',
      price: json['price']?.toString() ?? '0',
      isSelected: json['is_selected'] ?? false,
    );
  }
}
