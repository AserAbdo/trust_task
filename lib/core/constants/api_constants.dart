import 'dart:convert';
import 'env_config.dart';

class ApiConstants {
  // Private constructor to prevent instantiation
  ApiConstants._();

  static const String baseUrl = 'https://dushkaburger.com/wp-json/';

  /// Get credentials from secure environment config
  static String get _username => EnvConfig.apiUsername;
  static String get _password => EnvConfig.apiPassword;

  /// Generate Basic Auth header
  static String get authHeader {
    final credentials = '$_username:$_password';
    final encoded = base64Encode(utf8.encode(credentials));
    return 'Basic $encoded';
  }

  // API Endpoints
  static const String getGuestId = 'guestcart/v1/guestid';
  static const String getCategories = 'custom-api/v1/categories';
  static const String getProductDetails = 'custom-api/v1/products';
  static const String getProductAddons = 'proaddon/v1/get2/';
  static const String cart = 'guestcart/v1/cart';
}
