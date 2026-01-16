import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final int id;
  final String name;
  final String? image;
  final String? description;
  final int count;
  final List<Product> products;

  const Category({
    required this.id,
    required this.name,
    this.image,
    this.description,
    this.count = 0,
    this.products = const [],
  });

  @override
  List<Object?> get props => [id, name, image, description, count, products];
}

class Product extends Equatable {
  final int id;
  final String name;
  final String? description;
  final String? image;
  final String price;
  final String? regularPrice;
  final String? salePrice;
  final bool onSale;

  const Product({
    required this.id,
    required this.name,
    this.description,
    this.image,
    required this.price,
    this.regularPrice,
    this.salePrice,
    this.onSale = false,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    image,
    price,
    regularPrice,
    salePrice,
    onSale,
  ];
}
