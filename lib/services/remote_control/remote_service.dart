import 'package:glutter/models/remote_control/command.dart';
import 'package:glutter/models/shared/profile.dart';
import 'package:ssh/ssh.dart';

/// Provides services to interact with the server via SSH
class RemoteService {
  /// SSH-Client used for the connection
  SSHClient _sshClient;

  /// Ctor for RemoteService
  RemoteService(Profile server) {
    this._sshClient =
      new SSHClient(host: server.serverAddress, port: server.sshPort, username: server.sshUsername, passwordOrKey: server.sshPassword);
  }

  /// Executes SSH-Command to the current server
  execute(Command cmd) async {
    if (cmd != null) {
      await this._sshClient.connect();
      await this._sshClient.execute(cmd.commandMessage);
      await this._sshClient.disconnect();
    }
  }
}
