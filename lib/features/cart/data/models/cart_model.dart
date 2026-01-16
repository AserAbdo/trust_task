import '../../domain/entities/cart.dart';

class CartModel extends Cart {
  const CartModel({super.items, super.subtotal, super.tax, super.total});

  factory CartModel.fromJson(Map<String, dynamic> json) {
    List<CartItem> items = [];
    if (json['items'] != null) {
      items = (json['items'] as List)
          .map((item) => CartItemModel.fromJson(item))
          .toList();
    }

    final subtotal = double.tryParse(json['subtotal']?.toString() ?? '0') ?? 0;
    final tax = double.tryParse(json['tax']?.toString() ?? '0') ?? 0;
    final total = double.tryParse(json['total']?.toString() ?? '0') ?? 0;

    return CartModel(
      items: items,
      subtotal: subtotal,
      tax: tax,
      total: total > 0 ? total : subtotal + tax,
    );
  }

  factory CartModel.fromItems(List<CartItem> items) {
    final subtotal = items.fold<double>(0, (sum, item) => sum + item.itemTotal);
    final tax = subtotal * 0.14;
    final total = subtotal + tax;

    return CartModel(items: items, subtotal: subtotal, tax: tax, total: total);
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) {
        final cartItem = item as CartItemModel;
        return cartItem.toJson();
      }).toList(),
      'subtotal': subtotal,
      'tax': tax,
      'total': total,
    };
  }
}

class CartItemModel extends CartItem {
  const CartItemModel({
    required super.productId,
    required super.productName,
    super.productImage,
    required super.price,
    required super.quantity,
    super.addons,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    List<CartAddon> addons = [];
    if (json['addons'] != null) {
      addons = (json['addons'] as List)
          .map((addon) => CartAddon.fromJson(addon))
          .toList();
    }

    return CartItemModel(
      productId: json['product_id'] ?? json['productId'] ?? 0,
      productName:
          json['product_name'] ?? json['productName'] ?? json['name'] ?? '',
      productImage:
          json['product_image'] ?? json['productImage'] ?? json['image'],
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0,
      quantity: json['quantity'] ?? 1,
      addons: addons,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'product_name': productName,
      'product_image': productImage,
      'price': price,
      'quantity': quantity,
      'addons': addons.map((addon) => addon.toJson()).toList(),
    };
  }
}
