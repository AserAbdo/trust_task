import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/cart_model.dart';
import '../../domain/entities/cart.dart';
import '../../domain/usecases/cart_usecases.dart';
import 'cart_state.dart';

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

  Future<void> loadCart() async {
    // If cart is already loaded with items, just emit current state
    if (_localCart.isNotEmpty) {
      final cart = CartModel.fromItems(_localCart);
      emit(CartLoaded(cart: cart));
      return;
    }

    emit(CartLoading());

    final result = await getCartUseCase();

    result.fold(
      (failure) {
        // If API fails, use local cart
        final cart = CartModel.fromItems(_localCart);
        emit(CartLoaded(cart: cart));
      },
      (cart) {
        // Merge API cart with local cart
        if (cart.items.isNotEmpty) {
          _localCart = List.from(cart.items);
        }
        final currentCart = CartModel.fromItems(_localCart);
        emit(CartLoaded(cart: currentCart));
      },
    );
  }

  Future<void> addToCart({
    required int productId,
    required String productName,
    String? productImage,
    required double price,
    required int quantity,
    List<Map<String, dynamic>>? addons,
  }) async {
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
        CartItemModel(
          productId: productId,
          productName: productName,
          productImage: productImage,
          price: price,
          quantity: quantity,
          addons: cartAddons,
        ),
      );
    }

    _emitUpdatedCart();

    final result = await addToCartUseCase(
      productId: productId,
      quantity: quantity,
      addons: addons,
    );

    result.fold((failure) {}, (cart) {});
  }

  Future<void> removeFromCart(int productId) async {
    _localCart.removeWhere((item) => item.productId == productId);
    _emitUpdatedCart();

    await removeFromCartUseCase(productId: productId, quantity: 1);
  }

  Future<void> incrementQuantity(int productId) async {
    final index = _localCart.indexWhere((item) => item.productId == productId);
    if (index != -1) {
      final item = _localCart[index];
      _localCart[index] = item.copyWith(quantity: item.quantity + 1);
      _emitUpdatedCart();

      await addToCartUseCase(productId: productId, quantity: 1);
    }
  }

  Future<void> decrementQuantity(int productId) async {
    final index = _localCart.indexWhere((item) => item.productId == productId);
    if (index != -1) {
      final item = _localCart[index];
      if (item.quantity > 1) {
        _localCart[index] = item.copyWith(quantity: item.quantity - 1);
        _emitUpdatedCart();

        await removeFromCartUseCase(productId: productId, quantity: 1);
      } else {
        await removeFromCart(productId);
      }
    }
  }

  Future<void> clearCart() async {
    _localCart.clear();
    _emitUpdatedCart();

    await clearCartUseCase();
  }

  void applyCoupon(String code) {
    final currentState = state;
    if (currentState is CartLoaded) {
      emit(currentState.copyWith(couponCode: code));
    }
  }

  void _emitUpdatedCart() {
    final cart = CartModel.fromItems(_localCart);
    emit(CartLoaded(cart: cart));
  }

  int get itemCount => _localCart.fold(0, (sum, item) => sum + item.quantity);
}
