import 'env_config.dart';

/// API Constants for the application
///
/// Credentials are fetched from EnvConfig which uses:
/// 1. Secure Storage (encrypted on device)
/// 2. Build-time environment variables
/// 3. Development defaults (debug mode only)
class ApiConstants {
  // Private constructor to prevent instantiation
  ApiConstants._();

  /// Base URL for API calls
  static const String baseUrl = 'https://dushkaburger.com/wp-json/';

  /// Generate Basic Auth header using secure credentials
  /// Delegates to EnvConfig for credential management
  static String get authHeader => EnvConfig.basicAuthHeader;

  // ============ API Endpoints ============

  /// Guest cart endpoints
  static const String getGuestId = 'guestcart/v1/guestid';
  static const String cart = 'guestcart/v1/cart';

  /// Products endpoints
  static const String getCategories = 'custom-api/v1/categories';
  static const String getProductDetails = 'custom-api/v1/products';
  static const String getProductAddons = 'proaddon/v1/get2/';
}
