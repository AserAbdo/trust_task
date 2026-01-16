import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/utils/guest_manager.dart';
import '../models/cart_model.dart';

abstract class CartRemoteDataSource {
  Future<CartModel> getCart();
  Future<CartModel> addToCart({
    required int productId,
    required int quantity,
    List<Map<String, dynamic>>? addons,
  });
  Future<CartModel> removeFromCart({
    required int productId,
    required int quantity,
  });
  Future<CartModel> clearCart();
}

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final ApiClient apiClient;
  final GuestManager guestManager;

  CartRemoteDataSourceImpl({
    required this.apiClient,
    required this.guestManager,
  });

  @override
  Future<CartModel> getCart() async {
    final guestId = await guestManager.getGuestId();

    final response = await apiClient.get(
      ApiConstants.cart,
      queryParameters: {'guest_id': guestId},
    );

    if (response is Map<String, dynamic>) {
      return CartModel.fromJson(response);
    }

    return const CartModel();
  }

  @override
  Future<CartModel> addToCart({
    required int productId,
    required int quantity,
    List<Map<String, dynamic>>? addons,
  }) async {
    final guestId = await guestManager.getGuestId();

    final body = {
      'guest_id': guestId,
      'items': [
        {
          'product_id': productId,
          'quantity': quantity,
          if (addons != null && addons.isNotEmpty) 'addons': addons,
        },
      ],
    };

    final response = await apiClient.post(ApiConstants.cart, data: body);

    if (response is Map<String, dynamic>) {
      return CartModel.fromJson(response);
    }

    return await getCart();
  }

  @override
  Future<CartModel> removeFromCart({
    required int productId,
    required int quantity,
  }) async {
    final guestId = await guestManager.getGuestId();

    final body = {
      'guest_id': guestId,
      'product_id': productId,
      'quantity': quantity,
    };

    final response = await apiClient.delete(ApiConstants.cart, data: body);

    if (response is Map<String, dynamic>) {
      return CartModel.fromJson(response);
    }

    return await getCart();
  }

  @override
  Future<CartModel> clearCart() async {
    final guestId = await guestManager.getGuestId();

    await apiClient.delete(
      ApiConstants.cart,
      data: {'guest_id': guestId, 'clear_all': true},
    );

    return const CartModel();
  }
}
