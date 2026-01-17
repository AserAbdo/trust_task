import 'dart:convert';
import '../security/secure_credentials_manager.dart';

/// Environment and credentials configuration
///
/// Priority order for credentials:
/// 1. Secure Storage (flutter_secure_storage) - encrypted on device
/// 2. Build-time environment variables (--dart-define)
/// 3. Development defaults (only in debug mode)
class EnvConfig {
  // Private constructor to prevent instantiation
  EnvConfig._();

  static SecureCredentialsManager? _credentialsManager;
  static String? _cachedUsername;
  static String? _cachedPassword;
  static bool _initialized = false;

  /// Initialize the environment configuration
  /// Call this in main() before runApp()
  static Future<void> initialize({
    SecureCredentialsManager? credentialsManager,
  }) async {
    _credentialsManager = credentialsManager ?? SecureCredentialsManager();
    await _loadCredentials();
    _initialized = true;
  }

  /// Load credentials from secure storage
  static Future<void> _loadCredentials() async {
    if (_credentialsManager != null) {
      _cachedUsername = await _credentialsManager!.getApiUsername();
      _cachedPassword = await _credentialsManager!.getApiPassword();
    }
  }

  /// Check if EnvConfig has been initialized
  static bool get isInitialized => _initialized;

  /// Check if running in production mode
  static bool get isProduction {
    const mode = String.fromEnvironment('ENVIRONMENT', defaultValue: 'dev');
    return mode == 'production';
  }

  /// Check if running in debug mode
  static bool get isDebug {
    bool debug = false;
    assert(() {
      debug = true;
      return true;
    }());
    return debug;
  }

  // ============ Development defaults (ONLY used in debug mode) ============
  // In production, these should NEVER be used - credentials must come from
  // secure storage or environment variables
  static const String _devApiUsername = 'testapp';
  static const String _devApiPassword = '5S0Q YjyH 4s3G elpe 5F8v u8as';

  /// Get API username
  /// Priority: SecureStorage > Environment Variable > Dev Default (debug only)
  static String get apiUsername {
    // 1. Try secure storage (cached)
    if (_cachedUsername != null && _cachedUsername!.isNotEmpty) {
      return _cachedUsername!;
    }

    // 2. Try build-time environment variable
    const envUsername = String.fromEnvironment('API_USERNAME');
    if (envUsername.isNotEmpty) {
      return envUsername;
    }

    // 3. Fall back to dev defaults ONLY in debug mode
    if (isDebug && !isProduction) {
      return _devApiUsername;
    }

    // 4. In production without credentials, throw error
    throw StateError(
      'API credentials not configured. '
      'Set API_USERNAME via --dart-define or store in secure storage.',
    );
  }

  /// Get API password
  /// Priority: SecureStorage > Environment Variable > Dev Default (debug only)
  static String get apiPassword {
    // 1. Try secure storage (cached)
    if (_cachedPassword != null && _cachedPassword!.isNotEmpty) {
      return _cachedPassword!;
    }

    // 2. Try build-time environment variable
    const envPassword = String.fromEnvironment('API_PASSWORD');
    if (envPassword.isNotEmpty) {
      return envPassword;
    }

    // 3. Fall back to dev defaults ONLY in debug mode
    if (isDebug && !isProduction) {
      return _devApiPassword;
    }

    // 4. In production without credentials, throw error
    throw StateError(
      'API credentials not configured. '
      'Set API_PASSWORD via --dart-define or store in secure storage.',
    );
  }

  /// Generate Basic Auth header
  static String get basicAuthHeader {
    final credentials = '$apiUsername:$apiPassword';
    final encoded = base64Encode(utf8.encode(credentials));
    return 'Basic $encoded';
  }

  /// Store new API credentials in secure storage
  static Future<void> updateCredentials({
    required String username,
    required String password,
  }) async {
    if (_credentialsManager == null) {
      throw StateError('EnvConfig not initialized. Call initialize() first.');
    }

    await _credentialsManager!.storeApiCredentials(
      username: username,
      password: password,
    );

    // Update cache
    _cachedUsername = username;
    _cachedPassword = password;
  }

  /// Clear stored credentials
  static Future<void> clearCredentials() async {
    if (_credentialsManager != null) {
      await _credentialsManager!.clearAllCredentials();
    }
    _cachedUsername = null;
    _cachedPassword = null;
  }

  /// Check if credentials are available
  static bool get hasCredentials {
    try {
      // Try to access credentials - will throw if not available in production
      // ignore: unused_local_variable - intentional check
      apiUsername;
      apiPassword;
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get the credentials manager instance
  static SecureCredentialsManager? get credentialsManager =>
      _credentialsManager;
}
