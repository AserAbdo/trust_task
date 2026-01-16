import 'package:equatable/equatable.dart';
import '../../domain/entities/cart.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final Cart cart;
  final String? couponCode;
  final bool isApplyingCoupon;

  const CartLoaded({
    required this.cart,
    this.couponCode,
    this.isApplyingCoupon = false,
  });

  CartLoaded copyWith({
    Cart? cart,
    String? couponCode,
    bool? isApplyingCoupon,
  }) {
    return CartLoaded(
      cart: cart ?? this.cart,
      couponCode: couponCode ?? this.couponCode,
      isApplyingCoupon: isApplyingCoupon ?? this.isApplyingCoupon,
    );
  }

  @override
  List<Object?> get props => [cart, couponCode, isApplyingCoupon];
}

class CartError extends CartState {
  final String message;

  const CartError({required this.message});

  @override
  List<Object?> get props => [message];
}

class CartUpdating extends CartState {
  final Cart cart;

  const CartUpdating({required this.cart});

  @override
  List<Object?> get props => [cart];
}
