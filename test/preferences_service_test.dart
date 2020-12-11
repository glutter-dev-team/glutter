import 'package:glutter/services/shared/preferences_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/test.dart';

void main() {
  /// Tests functionality of PreferenceService
  test('Preferences Service set/get', () async {
    Map<String, dynamic> values = {'lastProfileId': 2};
    SharedPreferences.setMockInitialValues(values);

    int value = await PreferencesService.getLastProfileId();
    expect(value, 2);

    await PreferencesService.setLastProfileId(3);
    value = await PreferencesService.getLastProfileId();
    expect(value, 3);
  });
}
