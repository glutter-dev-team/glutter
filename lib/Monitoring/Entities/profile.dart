/// Represents a server-profile for monitoring with glances
class Profile {
  /// Server-Address without http or sth. and without port.
  String serverAddress;

  /// Server-Port. Glances-default: 61208
  String port;

  /// User-defined caption for this server.
  String caption;

  /// Defines the version of the Glances-API-Version (2 or 3)
  String glancesApiVersion;

  /// Returns the full server-address, includes http, port and the API-Version.
  String getFullServerAddress() {
    String fullServerAddress =  "http://" + this.serverAddress + ":" + this.port + "/api/" + this.glancesApiVersion;

    return fullServerAddress;
  }

  Profile(String serverAddress, String port, String caption, String apiVersion) {
    this.serverAddress = serverAddress;
    this.port = port;
    this.caption = caption;
    this.glancesApiVersion = apiVersion;
  }
}