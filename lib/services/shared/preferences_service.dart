import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static Future<void> setDefaultProfileId(int profileId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setInt('defaultProfileId', profileId);
  }

  static Future<int> getDefaultProfileId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getInt('defaultProfileId');
  }
}