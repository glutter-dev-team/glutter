import 'package:glutter/models/shared/profile.dart';
import 'package:glutter/services/shared/database_service.dart';
import 'package:glutter/services/shared/preferences_service.dart';


Profile getLastProfile() {
    Profile lastProfile;
/*    PreferencesService.getLastProfileId().then(
        (id) => DatabaseService.db.getProfileById(id).then(
            (profile) => lastProfile = profile
        )
    );*/
    _getLastProfileId().then((value) => _getSelectedProfile(value).then((value) => lastProfile = value));
    return lastProfile;
}


Future<int> _getLastProfileId() async {
    int profileId = await PreferencesService.getLastProfileId();
    return profileId;
}


Future<Profile> _getSelectedProfile(int id) async {
    Profile profile = await DatabaseService.db.getProfileById(id);
    return profile;
}

