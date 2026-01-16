import 'package:equatable/equatable.dart';

class ProductDetails extends Equatable {
  final int id;
  final String name;
  final String? description;
  final String? shortDescription;
  final String price;
  final String? regularPrice;
  final String? salePrice;
  final bool onSale;
  final List<String> images;
  final List<ProductAddon> addons;

  const ProductDetails({
    required this.id,
    required this.name,
    this.description,
    this.shortDescription,
    required this.price,
    this.regularPrice,
    this.salePrice,
    this.onSale = false,
    this.images = const [],
    this.addons = const [],
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    shortDescription,
    price,
    regularPrice,
    salePrice,
    onSale,
    images,
    addons,
  ];
}

class ProductAddon extends Equatable {
  final int id;
  final String name;
  final String price;
  final String type;
  final List<AddonOption> options;

  const ProductAddon({
    required this.id,
    required this.name,
    required this.price,
    this.type = 'checkbox',
    this.options = const [],
  });

  @override
  List<Object?> get props => [id, name, price, type, options];
}

class AddonOption extends Equatable {
  final String label;
  final String price;
  final bool isSelected;

  const AddonOption({
    required this.label,
    required this.price,
    this.isSelected = false,
  });

  AddonOption copyWith({bool? isSelected}) {
    return AddonOption(
      label: label,
      price: price,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  @override
  List<Object?> get props => [label, price, isSelected];
}
