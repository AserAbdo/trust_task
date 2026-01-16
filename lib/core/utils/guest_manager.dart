import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';
import '../network/api_client.dart';
import '../constants/api_constants.dart';

class GuestManager {
  final SharedPreferences _prefs;
  final ApiClient _apiClient;
  String? _guestId;

  GuestManager({required SharedPreferences prefs, required ApiClient apiClient})
    : _prefs = prefs,
      _apiClient = apiClient;

  Future<String> getGuestId() async {
    if (_guestId != null) return _guestId!;

    _guestId = _prefs.getString(AppConstants.guestIdKey);

    if (_guestId == null) {
      final response = await _apiClient.get(ApiConstants.getGuestId);
      _guestId = response['guest_id'] ?? response.toString();
      await _prefs.setString(AppConstants.guestIdKey, _guestId!);
    }

    return _guestId!;
  }

  Future<void> clearGuestId() async {
    _guestId = null;
    await _prefs.remove(AppConstants.guestIdKey);
  }
}
