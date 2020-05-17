import 'package:test/test.dart';
import 'package:glutter/services/monitoring/glances_service.dart';
import 'package:glutter/models/monitoring/profile.dart';

// skip this file to avoid getting errors when running your unit tests
@Skip("sqflite cannot run on the machine.")

void main() {
    /// Test-Constant "TestServer" -> Add your connection-values here!
    final Profile testServer = new Profile('seafileserver', '61208', 'Testserver', '2');

    /// Test-Constant "service", generated from the TestServer-Constant.
    final GlancesService service = new GlancesService(testServer);

    /// Group for all Tests for GlancesService.
    group('DataBaseServiceTests', () {
        // TODO: Add Tests for DB!
    });
}