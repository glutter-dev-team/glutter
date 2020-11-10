import 'package:glutter/models/shared/profile.dart';
import 'package:glutter/services/shared/database_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Implements services to interact with the Key-Value-Storage (on-device) using the SharedPreferences dart package.
class PreferencesService {
  /// Store a new profile ID as 'lastProfileId' in the Key-Value-Storage of SharedPreferences.
  static Future<void> setLastProfileId(int profileId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setInt('lastProfileId', profileId);
  }

  /// Get the current value of 'lastProfileId' in the Key-Value-Storage of SharedPreferences.
  static Future<int> getLastProfileId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getInt('lastProfileId');
  }

  /// Use the ID that is stored in the Key-Value-Storage and then get the actual last (most recently used) profile using the DatabaseService.
  static Future<Profile> getLastProfile() async {
    Profile lastProfile;
    int profileId = await getLastProfileId();

    if (profileId == null) {
      // if there's no profile ID stored in SharedPreferences, get the first profile in the list of all available profiles instead.
      DatabaseService.db.getProfiles().then((allProfiles) => () {
        lastProfile = allProfiles[0];
        setLastProfileId(lastProfile.id);
      });
    } else {
      lastProfile = await DatabaseService.db.getProfileById(profileId);
    }

    return lastProfile;
  }
}
