import 'package:test/test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:glutter/services/shared/preferences_service.dart';

void main() {
  /// Tests the correct functionality of getting the CPU-Values from the GlancesService.
  test('Preferences Service set/get', () async {
    Map<String, dynamic> values = {'defaultProfileId': 2};
    SharedPreferences.setMockInitialValues(values);

    int value = await PreferencesService.getDefaultProfileId();
    expect(value, 2);

    await PreferencesService.setDefaultProfileId(3);
    value = await PreferencesService.getDefaultProfileId();
    expect(value, 3);
  });

}