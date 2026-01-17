import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Secure storage keys
class SecureStorageKeys {
  SecureStorageKeys._();

  static const String apiUsername = 'api_username';
  static const String apiPassword = 'api_password';
  static const String authToken = 'auth_token';
  static const String refreshToken = 'refresh_token';
  static const String userSession = 'user_session';
}

/// Secure credentials manager using encrypted storage
/// Uses platform-specific encryption:
/// - iOS: Keychain
/// - Android: AES encryption with RSA-encrypted key stored in KeyStore
/// - Web: Uses local storage (less secure, consider alternatives for web)
class SecureCredentialsManager {
  final FlutterSecureStorage _secureStorage;

  /// Android options for enhanced security
  static const _androidOptions = AndroidOptions(
    encryptedSharedPreferences: true,
    sharedPreferencesName: 'trust_task_secure_prefs',
    preferencesKeyPrefix: 'tt_',
  );

  /// iOS options for keychain access
  static const _iosOptions = IOSOptions(
    accessibility: KeychainAccessibility.first_unlock_this_device,
    accountName: 'trust_task_credentials',
  );

  SecureCredentialsManager({FlutterSecureStorage? secureStorage})
    : _secureStorage =
          secureStorage ??
          const FlutterSecureStorage(
            aOptions: _androidOptions,
            iOptions: _iosOptions,
          );

  /// Store API credentials securely
  Future<void> storeApiCredentials({
    required String username,
    required String password,
  }) async {
    await _secureStorage.write(
      key: SecureStorageKeys.apiUsername,
      value: username,
    );
    await _secureStorage.write(
      key: SecureStorageKeys.apiPassword,
      value: password,
    );
  }

  /// Retrieve API username
  Future<String?> getApiUsername() async {
    return await _secureStorage.read(key: SecureStorageKeys.apiUsername);
  }

  /// Retrieve API password
  Future<String?> getApiPassword() async {
    return await _secureStorage.read(key: SecureStorageKeys.apiPassword);
  }

  /// Store authentication token
  Future<void> storeAuthToken(String token) async {
    await _secureStorage.write(key: SecureStorageKeys.authToken, value: token);
  }

  /// Retrieve authentication token
  Future<String?> getAuthToken() async {
    return await _secureStorage.read(key: SecureStorageKeys.authToken);
  }

  /// Store refresh token
  Future<void> storeRefreshToken(String token) async {
    await _secureStorage.write(
      key: SecureStorageKeys.refreshToken,
      value: token,
    );
  }

  /// Retrieve refresh token
  Future<String?> getRefreshToken() async {
    return await _secureStorage.read(key: SecureStorageKeys.refreshToken);
  }

  /// Store user session data (JSON string)
  Future<void> storeUserSession(String sessionData) async {
    await _secureStorage.write(
      key: SecureStorageKeys.userSession,
      value: sessionData,
    );
  }

  /// Retrieve user session data
  Future<String?> getUserSession() async {
    return await _secureStorage.read(key: SecureStorageKeys.userSession);
  }

  /// Check if credentials are stored
  Future<bool> hasStoredCredentials() async {
    final username = await getApiUsername();
    final password = await getApiPassword();
    return username != null && password != null;
  }

  /// Clear all credentials (logout)
  Future<void> clearAllCredentials() async {
    await _secureStorage.delete(key: SecureStorageKeys.apiUsername);
    await _secureStorage.delete(key: SecureStorageKeys.apiPassword);
    await _secureStorage.delete(key: SecureStorageKeys.authToken);
    await _secureStorage.delete(key: SecureStorageKeys.refreshToken);
    await _secureStorage.delete(key: SecureStorageKeys.userSession);
  }

  /// Clear only session data (keep API credentials)
  Future<void> clearSession() async {
    await _secureStorage.delete(key: SecureStorageKeys.authToken);
    await _secureStorage.delete(key: SecureStorageKeys.refreshToken);
    await _secureStorage.delete(key: SecureStorageKeys.userSession);
  }

  /// Delete all secure storage data
  Future<void> deleteAll() async {
    await _secureStorage.deleteAll();
  }

  /// Read a custom key from secure storage
  Future<String?> read(String key) async {
    return await _secureStorage.read(key: key);
  }

  /// Write a custom key-value pair to secure storage
  Future<void> write(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  /// Delete a custom key from secure storage
  Future<void> delete(String key) async {
    await _secureStorage.delete(key: key);
  }

  /// Check if a key exists in secure storage
  Future<bool> containsKey(String key) async {
    return await _secureStorage.containsKey(key: key);
  }
}
