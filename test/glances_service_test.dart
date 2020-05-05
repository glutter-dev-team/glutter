import 'package:test/test.dart';
import 'package:glutter/Monitoring/Entities/profile.dart';
import 'package:glutter/Monitoring/Entities/cpu.dart';
import 'package:glutter/Monitoring/Entities/memory.dart';
import 'package:glutter/Monitoring/Entities/network.dart';
import 'package:glutter/Monitoring/Entities/sensor.dart';
import 'package:glutter/Monitoring/Services/glances_service.dart';

void main() {
    /// Test-Constant "TestServer" -> Add your connection-values here!
    final Profile testServer = new Profile('seafileserver', '61208', 'Testserver', '2');

    /// Test-Constant "service", generated from the TestServer-Constant.
    final GlancesService service = new GlancesService(testServer);

    /// Group for all Tests for GlancesService.
    group('GlancesService', () {

        /// Tests the correct functionality of getting the CPU-Values from the GlancesService.
        test('GlancesService CPU', () async {
            CPU cpu = await service.getCpu();

            expect(cpu.cpuCore, greaterThan(0));
        });

        /// Tests the correct functionality of getting the Memory-Values from the GlancesService.
        test('GlancesService Memory', () async {
            Memory memory = await service.getMemory();

            expect(memory.total, greaterThan(0));
            expect(memory.total, lessThan(90000000000));
        });

        /// Tests the correct functionality of getting the Network-Values from the GlancesService.
        test('GlancesService Network', () async {
            List<Network> networks = await service.getNetworks();

            expect(networks.length, greaterThan(0));
        });

        /// Tests the correct functionality of getting the Sensor-Values from the GlancesService.
        test('GlancesService Sensors', () async {
            List<Sensor> sensors = await service.getSensors();

            expect(sensors.length, greaterThan(0));
        });
    });
}