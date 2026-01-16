import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/cart.dart';
import '../../domain/usecases/cart_usecases.dart';
import 'cart_state.dart';

/// Cubit for managing cart state
class CartCubit extends Cubit<CartState> {
  final GetCartUseCase getCartUseCase;
  final AddToCartUseCase addToCartUseCase;
  final RemoveFromCartUseCase removeFromCartUseCase;
  final ClearCartUseCase clearCartUseCase;

  List<CartItem> _localCart = [];

  CartCubit({
    required this.getCartUseCase,
    required this.addToCartUseCase,
    required this.removeFromCartUseCase,
    required this.clearCartUseCase,
  }) : super(CartInitial());

  /// Load cart from API or use local cart
  Future<void> loadCart() async {
    // If cart is already loaded with items, just emit current state
    if (_localCart.isNotEmpty) {
      final cart = Cart.fromItems(_localCart);
      emit(CartLoaded(cart: cart));
      return;
    }

    emit(CartLoading());

    final result = await getCartUseCase(const NoParams());

    result.fold(
      (failure) {
        // If API fails, use local cart
        final cart = Cart.fromItems(_localCart);
        emit(CartLoaded(cart: cart));
      },
      (cart) {
        // Merge API cart with local cart
        if (cart.items.isNotEmpty) {
          _localCart = List.from(cart.items);
        }
        final currentCart = Cart.fromItems(_localCart);
        emit(CartLoaded(cart: currentCart));
      },
    );
  }

  /// Add item to cart
  Future<void> addToCart({
    required int productId,
    required String productName,
    String? productNameAr,
    String? productImage,
    required double price,
    required int quantity,
    List<Map<String, dynamic>>? addons,
  }) async {
    emit(CartUpdating(cart: Cart.fromItems(_localCart)));

    final existingIndex = _localCart.indexWhere(
      (item) => item.productId == productId,
    );

    List<CartAddon> cartAddons = [];
    if (addons != null) {
      cartAddons = addons.map((a) => CartAddon.fromJson(a)).toList();
    }

    if (existingIndex != -1) {
      final existingItem = _localCart[existingIndex];
      _localCart[existingIndex] = existingItem.copyWith(
        quantity: existingItem.quantity + quantity,
      );
    } else {
      _localCart.add(
        CartItem(
          productId: productId,
          productName: productName,
          productNameAr: productNameAr,
          productImage: productImage,
          price: price,
          quantity: quantity,
          addons: cartAddons,
        ),
      );
    }

    _emitUpdatedCart();

    // Sync with API in background
    final result = await addToCartUseCase(
      AddToCartParams(productId: productId, quantity: quantity, addons: addons),
    );

    result.fold((failure) {}, (cart) {});
  }

  /// Remove item from cart
  Future<void> removeFromCart(int productId) async {
    emit(CartUpdating(cart: Cart.fromItems(_localCart)));

    _localCart.removeWhere((item) => item.productId == productId);
    _emitUpdatedCart();

    await removeFromCartUseCase(
      RemoveFromCartParams(productId: productId, quantity: 1),
    );
  }

  /// Increment item quantity
  Future<void> incrementQuantity(int productId) async {
    final index = _localCart.indexWhere((item) => item.productId == productId);
    if (index != -1) {
      emit(CartUpdating(cart: Cart.fromItems(_localCart)));

      final item = _localCart[index];
      _localCart[index] = item.copyWith(quantity: item.quantity + 1);
      _emitUpdatedCart();

      await addToCartUseCase(
        AddToCartParams(productId: productId, quantity: 1),
      );
    }
  }

  /// Decrement item quantity
  Future<void> decrementQuantity(int productId) async {
    final index = _localCart.indexWhere((item) => item.productId == productId);
    if (index != -1) {
      final item = _localCart[index];
      if (item.quantity > 1) {
        emit(CartUpdating(cart: Cart.fromItems(_localCart)));

        _localCart[index] = item.copyWith(quantity: item.quantity - 1);
        _emitUpdatedCart();

        await removeFromCartUseCase(
          RemoveFromCartParams(productId: productId, quantity: 1),
        );
      } else {
        await removeFromCart(productId);
      }
    }
  }

  /// Clear all items from cart
  Future<void> clearCart() async {
    emit(CartUpdating(cart: Cart.fromItems(_localCart)));

    _localCart.clear();
    _emitUpdatedCart();

    await clearCartUseCase(const NoParams());
  }

  /// Apply coupon code
  void applyCoupon(String code) {
    final currentState = state;
    if (currentState is CartLoaded) {
      emit(currentState.copyWith(couponCode: code));
    }
  }

  void _emitUpdatedCart() {
    final cart = Cart.fromItems(_localCart);
    emit(CartLoaded(cart: cart));
  }

  /// Get total item count in cart
  int get itemCount => _localCart.fold(0, (sum, item) => sum + item.quantity);
}
