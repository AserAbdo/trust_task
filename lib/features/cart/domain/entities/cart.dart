import 'package:equatable/equatable.dart';

class Cart extends Equatable {
  final List<CartItem> items;
  final double subtotal;
  final double tax;
  final double total;

  const Cart({
    this.items = const [],
    this.subtotal = 0,
    this.tax = 0,
    this.total = 0,
  });

  Cart copyWith({
    List<CartItem>? items,
    double? subtotal,
    double? tax,
    double? total,
  }) {
    return Cart(
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      tax: tax ?? this.tax,
      total: total ?? this.total,
    );
  }

  @override
  List<Object?> get props => [items, subtotal, tax, total];
}

class CartItem extends Equatable {
  final int productId;
  final String productName; // English name
  final String? productNameAr; // Arabic name
  final String? productImage;
  final double price;
  final int quantity;
  final List<CartAddon> addons;

  const CartItem({
    required this.productId,
    required this.productName,
    this.productNameAr,
    this.productImage,
    required this.price,
    required this.quantity,
    this.addons = const [],
  });

  /// Get localized product name based on language code
  String getLocalizedName(String languageCode) {
    if (languageCode == 'ar' &&
        productNameAr != null &&
        productNameAr!.isNotEmpty) {
      return productNameAr!;
    }
    return productName;
  }

  double get itemTotal {
    double addonTotal = addons.fold(
      0,
      (sum, addon) => sum + (double.tryParse(addon.price) ?? 0),
    );
    return (price + addonTotal) * quantity;
  }

  CartItem copyWith({
    int? productId,
    String? productName,
    String? productNameAr,
    String? productImage,
    double? price,
    int? quantity,
    List<CartAddon>? addons,
  }) {
    return CartItem(
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      productNameAr: productNameAr ?? this.productNameAr,
      productImage: productImage ?? this.productImage,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      addons: addons ?? this.addons,
    );
  }

  @override
  List<Object?> get props => [
    productId,
    productName,
    productNameAr,
    productImage,
    price,
    quantity,
    addons,
  ];
}

class CartAddon extends Equatable {
  final int id;
  final String name;
  final String? nameAr;
  final String price;

  const CartAddon({
    required this.id,
    required this.name,
    this.nameAr,
    required this.price,
  });

  factory CartAddon.fromJson(Map<String, dynamic> json) {
    return CartAddon(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      nameAr: json['nameAr'],
      price: json['price']?.toString() ?? '0',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'nameAr': nameAr, 'price': price};
  }

  @override
  List<Object?> get props => [id, name, nameAr, price];
}
