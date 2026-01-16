import 'package:equatable/equatable.dart';
import '../../domain/entities/product_details.dart';

abstract class ProductDetailsState extends Equatable {
  const ProductDetailsState();

  @override
  List<Object?> get props => [];
}

class ProductDetailsInitial extends ProductDetailsState {}

class ProductDetailsLoading extends ProductDetailsState {}

class ProductDetailsLoaded extends ProductDetailsState {
  final ProductDetails product;
  final int quantity;
  final Map<int, List<String>> selectedOptions;
  final double totalPrice;

  const ProductDetailsLoaded({
    required this.product,
    this.quantity = 1,
    this.selectedOptions = const {},
    required this.totalPrice,
  });

  ProductDetailsLoaded copyWith({
    ProductDetails? product,
    int? quantity,
    Map<int, List<String>>? selectedOptions,
    double? totalPrice,
  }) {
    return ProductDetailsLoaded(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      selectedOptions: selectedOptions ?? this.selectedOptions,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }

  @override
  List<Object?> get props => [product, quantity, selectedOptions, totalPrice];
}

class ProductDetailsError extends ProductDetailsState {
  final String message;

  const ProductDetailsError({required this.message});

  @override
  List<Object?> get props => [message];
}
