import 'package:glutter/models/shared/profile.dart';
import 'package:glutter/services/shared/database_service.dart';
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

  static Future<Profile> getLastProfile() async {
    Profile lastProfile;
    int profileId = await getLastProfileId();

    if (lastProfile == null) {
      Future profilesFuture = DatabaseService.db.getProfiles();
      profilesFuture.then((value) => lastProfile = value[0]);
      setLastProfileId(lastProfile.id);

    } else {
      lastProfile = await DatabaseService.db.getProfileById(profileId);
    }

    return lastProfile;
  }
}
