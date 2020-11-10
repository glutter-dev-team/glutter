import 'package:glutter/models/monitoring/cpu.dart';
import 'package:glutter/models/monitoring/memory.dart';
import 'package:glutter/models/monitoring/network.dart';
import 'package:glutter/models/monitoring/sensor.dart';
import 'package:glutter/models/shared/profile.dart';
import 'package:glutter/services/monitoring/glances_service.dart';
import 'package:test/test.dart';

void main() {
  /// Test-Constant "TestServer" -> Add your connection-values here!
  final Profile testServer = new Profile('192.168.2.126', 61208, '2', 'Testserver', 22, 'admin');

  /// Test-Constant "service", generated from the TestServer-Constant.
  final GlancesService service = new GlancesService(testServer);

  /// Group for all Tests for GlancesService.
  group('GlancesServiceTests', () {
    /// Tests the correct functionality of getting the CPU-Values from the GlancesService.
    test('GlancesServiceTest CPU', () async {
      CPU cpu = await service.getCpu();

      expect(cpu.cpuCore, greaterThan(0));
    });

    /// Tests the correct functionality of getting the Memory-Values from the GlancesService.
    test('GlancesServiceTest Memory', () async {
      Memory memory = await service.getMemory();

      expect(memory.total, greaterThan(0));
      expect(memory.total, lessThan(90000000000));
    });

    /// Tests the correct functionality of getting the Network-Values from the GlancesService.
    test('GlancesServiceTest Network', () async {
      List<Network> networks = await service.getNetworks();

      expect(networks.length, greaterThan(0));
    });

    /// Tests the correct functionality of getting the Sensor-Values from the GlancesService.
    test('GlancesServiceTest Sensors', () async {
      List<Sensor> sensors = await service.getSensors();

      expect(sensors.length, greaterThan(0));
    });

    /// Tests the correct functionality of performing connection-Test.
    test('GlancesServiceTest ConnectionTest', () async {
      bool isSuccess = await service.connectionTest();

      expect(isSuccess, equals(true));
    });
  });
}
