/// Environment configuration
/// In production, these should come from secure environment variables
/// or a secure vault service
class EnvConfig {
  // Private constructor to prevent instantiation
  EnvConfig._();

  /// Get API credentials from environment or secure storage
  /// For development/demo purposes, using constants
  /// TODO: Replace with secure environment variables in production
  ///
  /// Options for production:
  /// 1. Use flutter_dotenv package with .env file (gitignored)
  /// 2. Use --dart-define flags during build
  /// 3. Use native secure storage per platform
  /// 4. Fetch from a secure backend on app start

  static const String _devApiUsername = 'testapp';
  static const String _devApiPassword = '5S0Q YjyH 4s3G elpe 5F8v u8as';

  /// Get API username
  /// In production, use: String.fromEnvironment('API_USERNAME')
  static String get apiUsername {
    const envUsername = String.fromEnvironment('API_USERNAME');
    return envUsername.isNotEmpty ? envUsername : _devApiUsername;
  }

  /// Get API password
  /// In production, use: String.fromEnvironment('API_PASSWORD')
  static String get apiPassword {
    const envPassword = String.fromEnvironment('API_PASSWORD');
    return envPassword.isNotEmpty ? envPassword : _devApiPassword;
  }

  /// Check if running in production mode
  static bool get isProduction {
    const mode = String.fromEnvironment('ENVIRONMENT', defaultValue: 'dev');
    return mode == 'production';
  }
}
