import 'dart:convert';

class ApiConstants {
  static const String baseUrl = 'https://dushkaburger.com/wp-json/';
  static const String username = 'testapp';
  static const String password = '5S0Q YjyH 4s3G elpe 5F8v u8as';

  static String get authHeader {
    final credentials = '$username:$password';
    final encoded = base64Encode(utf8.encode(credentials));
    return 'Basic $encoded';
  }

  static const String getGuestId = 'guestcart/v1/guestid';
  static const String getCategories = 'custom-api/v1/categories';
  static const String getProductDetails = 'custom-api/v1/products';
  static const String getProductAddons = 'proaddon/v1/get2/';
  static const String cart = 'guestcart/v1/cart';
}
