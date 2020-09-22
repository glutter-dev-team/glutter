import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static Future<void> setLastProfileId(int profileId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setInt('lastProfileId', profileId);
  }

  static Future<int> getLastProfileId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getInt('lastProfileId');
  }
}
