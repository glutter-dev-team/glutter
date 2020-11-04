/// Represents a server-profile for monitoring with glances
class Profile {
    /// The ID of the server for database.
    int id;

    /// Server-Address without http or sth. and without port.
    String serverAddress;

    /// Server-Port. Glances-default: 61208
    int port;

    /// Defines the version of the Glances-API-Version (2 or 3)
    String glancesApiVersion;

    /// User-defined caption for this server.
    String caption;

    /// Server-Port for SSH. Default: 22
    int sshPort;

    /// Username for SSH
    String sshUsername;

    /// Server-Password for SSH. Not stored in the database!
    String sshPassword;

    /// Returns the full server-address, includes http, port and the API-Version.
    String getFullServerAddress() {
        String fullServerAddress =  "http://" + this.serverAddress + ":" + this.port.toString() + "/api/" + this.glancesApiVersion;

        return fullServerAddress;
    }

    String getSshAddress() {
        String sshAddress = this.serverAddress + ":" + this.sshPort.toString();

        return sshAddress;
    }

    /// Constructor for Profile.
    Profile(String serverAddress, int port, String apiVersion, String caption, int sshPort, String sshUsername) {
        this.serverAddress = serverAddress;
        this.port = port;
        this.caption = caption;
        this.glancesApiVersion = apiVersion;
        this.sshPort = sshPort;
        this.sshUsername = sshUsername;
    }

    /// Converts data from Database into Profiles.
    static Profile fromMap(Map<String, dynamic> map) {
        return _fromDatabase(
            map["id"],
            map["serverAddress"],
            map["port"],
            map["glancesApiVersion"],
            map["caption"],
            map["sshPort"],
            map["sshUsername"]
        );
    }

    /// Constructor for Profiles by the Database.
    static Profile _fromDatabase(int id, String serverAddress, int port, String apiVersion, String caption, int sshPort, String sshUsername) {
        Profile profile = new Profile(serverAddress, port, apiVersion, caption, sshPort, sshUsername);

        profile.id = id;

        return profile;
    }

    /// Converts the object into a map for storing it into the database.
    Map<String, dynamic> toMap() {
        return {
            "id" : this.id,
            "serverAddress" : this.serverAddress,
            "port" : this.port,
            "glancesApiVersion" : this.glancesApiVersion,
            "caption" : this.caption,
            "sshPort" : this.sshPort,
            "sshUsername" : this.sshUsername
        };
    }

    bool operator == (dynamic other) =>
        other != null && other is Profile && this.id == other.id;

    @override
    int get hashCode => id.hashCode;
}