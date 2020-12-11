import 'package:glutter/models/remote_control/command.dart';
import 'package:glutter/models/shared/profile.dart';
import 'package:glutter/services/remote_control/remote_service.dart';
import 'package:test/test.dart';

void main() {
  /// Test-Constant "TestServer" -> Add your connection-values here!
  Profile testServer = new Profile('192.168.2.126', 61208, '2', 'Testserver', 22, 'srvadmin');
  testServer.sshPassword = "*****";

  /// Test-Constant "remoteService", generated from the TestServer.
  final remoteService = new RemoteService(testServer);

  /// Group for all Tests for RemoteService.
  group('RemoteServiceTests', () {
    /// Tests the correct functionality of getting the CPU-Values from the GlancesService.
    test('RemoteService ExecuteCommand', () async {
      Command cmd = new Command("sudo service apache2 stop", "Test", 0);
      var result = await remoteService.execute(cmd);
      print(result);
    });
  });
}
