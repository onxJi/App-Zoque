import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _keyFirstTime = 'is_first_time';

  static PreferencesService? _instance;
  static SharedPreferences? _preferences;

  PreferencesService._();

  static Future<PreferencesService> getInstance() async {
    _instance ??= PreferencesService._();
    _preferences ??= await SharedPreferences.getInstance();
    return _instance!;
  }

  // Check if it's the first time the app is opened
  bool get isFirstTime {
    return _preferences?.getBool(_keyFirstTime) ?? true;
  }

  // Mark that the app has been opened before
  Future<void> setNotFirstTime() async {
    await _preferences?.setBool(_keyFirstTime, false);
  }

  // Reset first time flag (useful for testing)
  Future<void> resetFirstTime() async {
    await _preferences?.setBool(_keyFirstTime, true);
  }
}
