import 'package:test/test.dart';
import 'package:glutter/models/monitoring/cpu.dart';
import 'package:glutter/models/monitoring/memory.dart';
import 'package:glutter/models/monitoring/network.dart';
import 'package:glutter/models/monitoring/sensor.dart';

void main() {
    /// Group for all Tests testing Models.
    group('ModelsTest', () {
        /// Group for all Tests testing CPU-Model
        group('CPU Test', () {
            /// Tests the correct functionality of the CPU-Ctor.
            test('Ctor Test CPU', () async {
                CPU cpu = new CPU(1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0, 11.0, 12, 13, 14, 15, 16.0, 17);

                expect(1.0, cpu.totalLoad);
                expect(2.0, cpu.user);
                expect(3.0, cpu.system);
                expect(4.0, cpu.idle);
                expect(5.0, cpu.nice);
                expect(6.0, cpu.ioWait);
                expect(7.0, cpu.interruptRequest);
                expect(8.0, cpu.softInterruptRequest);
                expect(9.0, cpu.steal);
                expect(10.0, cpu.guest);
                expect(11.0, cpu.guestNice);
                expect(12, cpu.ctxSwitches);
                expect(13, cpu.interrupts);
                expect(14, cpu.softwareInterrupts);
                expect(15, cpu.systemCalls);
                expect(16.0, cpu.timeSinceUpdate);
                expect(17, cpu.cpuCore);
            });

            /// Tests the correct functionality of the factory converting Json-Values into CPU-Objects.
            test('Factory Test CPU', () async {
                // Test with correct Double-Parameters
                Map<String, dynamic> map = {
                    'total': 1.0,
                    'user': 2.0,
                    'system': 3.0,
                    'idle': 4.0,
                    'nice': 5.0,
                    'iowait': 6.0,
                    'irq': 7.0,
                    'softirq': 8.0,
                    'steal': 9.0,
                    'guest': 10.0,
                    'guest_nice': 11.0,
                    'ctx_switches': 12,
                    'interrupts': 13,
                    'soft_interrupts': 14,
                    'syscalls': 15,
                    'time_since_update': 16.0,
                    'cpucore': 17
                };

                CPU cpu = CPU.fromJson(map);

                expect(cpu.totalLoad, 1.0);
                expect(cpu.user, 2.0);
                expect(cpu.system, 3.0);
                expect(cpu.idle, 4.0);
                expect(cpu.nice, 5.0);
                expect(cpu.ioWait, 6.0);
                expect(cpu.interruptRequest, 7.0);
                expect(cpu.softInterruptRequest, 8.0);
                expect(cpu.steal, 9.0);
                expect(cpu.guest, 10.0);
                expect(cpu.guestNice, 11.0);
                expect(cpu.ctxSwitches, 12);
                expect(cpu.interrupts, 13);
                expect(cpu.softwareInterrupts, 14);
                expect(cpu.systemCalls, 15);
                expect(cpu.timeSinceUpdate, 16.0);
                expect(cpu.cpuCore, 17);


                // Test with incorrect double-Parameters.
                Map<String, dynamic> map2 = {
                    'total': 1,
                    'user': 2,
                    'system': 3,
                    'idle': 4,
                    'nice': 5,
                    'iowait': 6,
                    'irq': 7,
                    'softirq': 8,
                    'steal': 9,
                    'guest': 10,
                    'guest_nice': 11,
                    'ctx_switches': 12,
                    'interrupts': 13,
                    'soft_interrupts': 14,
                    'syscalls': 15,
                    'time_since_update': 16,
                    'cpucore': 17
                };

                CPU cpu2 = CPU.fromJson(map2);

                // They should be casted into double-values.
                expect(cpu2.totalLoad, 1.0);
                expect(cpu2.user, 2.0);
                expect(cpu2.system, 3.0);
                expect(cpu2.idle, 4.0);
                expect(cpu2.nice, 5.0);
                expect(cpu2.ioWait, 6.0);
                expect(cpu2.interruptRequest, 7.0);
                expect(cpu2.softInterruptRequest, 8.0);
                expect(cpu2.steal, 9.0);
                expect(cpu2.guest, 10.0);
                expect(cpu2.guestNice, 11.0);
                expect(cpu2.ctxSwitches, 12);
                expect(cpu2.interrupts, 13);
                expect(cpu2.softwareInterrupts, 14);
                expect(cpu2.systemCalls, 15);
                expect(cpu2.timeSinceUpdate, 16.0);
                expect(cpu2.cpuCore, 17);
            });
        });

        group('Memory Test', () {
            /// Tests the correct functionality of the Memory-Ctor.
            test('Ctor Test Memory', () async {
                Memory mem = new Memory(1, 2, 3.0, 4, 5, 6, 7, 8, 9, 10);

                expect(1, mem.total);
                expect(2, mem.available);
                expect(3.0, mem.usagePercent);
                expect(4, mem.used);
                expect(5, mem.free);
                expect(6, mem.active);
                expect(7, mem.inactive);
                expect(8, mem.buffers);
                expect(9, mem.cached);
                expect(10, mem.shared);
            });

            /// Tests the correct functionality of the factory converting Json-Values into Memory-Objects.
            test('Factory Test Memory', () async {
                // Test with correct Double-Parameters
                Map<String, dynamic> map = {
                    'total': 1,
                    'available': 2,
                    'percent': 3.0,
                    'used': 4,
                    'free': 5,
                    'active': 6,
                    'inactive': 7,
                    'buffers': 8,
                    'cached': 9,
                    'shared': 10,
                };

                Memory mem = Memory.fromJson(map);

                expect(mem.total, 1);
                expect(mem.available, 2);
                expect(mem.usagePercent, 3.0);
                expect(mem.used, 4);
                expect(mem.free, 5);
                expect(mem.active, 6);
                expect(mem.inactive, 7);
                expect(mem.buffers, 8);
                expect(mem.cached, 9);
                expect(mem.shared, 10);

                // Test with correct Double-Parameters
                Map<String, dynamic> map2 = {
                    'total': 1,
                    'available': 2,
                    'percent': 3,
                    'used': 4,
                    'free': 5,
                    'active': 6,
                    'inactive': 7,
                    'buffers': 8,
                    'cached': 9,
                    'shared': 10,
                };

                Memory mem2 = Memory.fromJson(map2);

                expect(mem2.total, 1);
                expect(mem2.available, 2);
                expect(mem2.usagePercent, 3.0);
                expect(mem2.used, 4);
                expect(mem2.free, 5);
                expect(mem2.active, 6);
                expect(mem2.inactive, 7);
                expect(mem2.buffers, 8);
                expect(mem2.cached, 9);
                expect(mem2.shared, 10);
            });
        });

        group('Network Test', () {

            test('Ctor Test Network', () async {
                Network net = new Network("Testinterface", 2.0, 3, 4, 5, 6, 7, 8, true, 10, "Test");

                expect("Testinterface", net.interfaceName);
                expect(2.0, net.timeSinceUpdate);
                expect(3, net.cumulativeReceive);
                expect(4, net.receive);
                expect(5, net.cumulativeTx);
                expect(6, net.tx);
                expect(7, net.cumulativeCx);
                expect(8, net.cx);
                expect(true, net.isUp);
                expect(10, net.speed);
                expect("Test", net.key);
            });

            /// Tests the correct functionality of the factory converting Json-Values into Memory-Objects.
            test('Factory Test Memory', () async {
                // Test with correct Double-Parameters
                Map<String, dynamic> map = {
                    'interface_name': 'Testinterface',
                    'time_since_update': 2.0,
                    'cumulative_rx': 3,
                    'rx': 4,
                    'cumulative_tx': 5,
                    'tx': 6,
                    'cumulative_cx': 7,
                    'cx': 8,
                    'is_up': true,
                    'speed': 10,
                    'key' : 'Test'
                };

                Network net = Network.fromJson(map);

                expect("Testinterface", net.interfaceName);
                expect(2.0, net.timeSinceUpdate);
                expect(3, net.cumulativeReceive);
                expect(4, net.receive);
                expect(5, net.cumulativeTx);
                expect(6, net.tx);
                expect(7, net.cumulativeCx);
                expect(8, net.cx);
                expect(true, net.isUp);
                expect(10, net.speed);
                expect("Test", net.key);


                // Test with incorrect Double-Parameters
                Map<String, dynamic> map2 = {
                    'interface_name': 'Testinterface',
                    'time_since_update': 2,
                    'cumulative_rx': 3,
                    'rx': 4,
                    'cumulative_tx': 5,
                    'tx': 6,
                    'cumulative_cx': 7,
                    'cx': 8,
                    'is_up': true,
                    'speed': 10,
                    'key' : 'Test'
                };

                Network net2 = Network.fromJson(map2);

                expect("Testinterface", net2.interfaceName);
                expect(2.0, net2.timeSinceUpdate);
                expect(3, net2.cumulativeReceive);
                expect(4, net2.receive);
                expect(5, net2.cumulativeTx);
                expect(6, net2.tx);
                expect(7, net2.cumulativeCx);
                expect(8, net2.cx);
                expect(true, net2.isUp);
                expect(10, net2.speed);
                expect("Test", net2.key);
            });
        });

        group('Sensor Test', () {
            test('Ctor Test Sensor', () async {
                Sensor sens = new Sensor("TestSensor", 2, "C", "TestType", "TestSensor");

                expect("TestSensor", sens.label);
                expect(2, sens.value);
                expect("C", sens.unit);
                expect("TestType", sens.type);
                expect("TestSensor", sens.key);
            });

            /// Tests the correct functionality of the factory converting Json-Values into Sensor-Objects.
            test('Factory Test Sensor', () async {
                // Test with correct Double-Parameters
                Map<String, dynamic> map = {
                    'label': 'TestSensor',
                    'value': 2,
                    'unit': 'C',
                    'type': 'TestType',
                    'key': 'TestSensor',
                };

                Sensor sens = Sensor.fromJson(map);

                expect("TestSensor", sens.label);
                expect(2, sens.value);
                expect("C", sens.unit);
                expect("TestType", sens.type);
                expect("TestSensor", sens.key);
            });
        });

    });
}