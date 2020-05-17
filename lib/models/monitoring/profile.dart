/// Represents a server-profile for monitoring with glances
class Profile {
    /// The ID of the server for database.
    int id;

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

    /// Constructor for Profile.
    Profile(String serverAddress, String port, String caption, String apiVersion) {
        this.serverAddress = serverAddress;
        this.port = port;
        this.caption = caption;
        this.glancesApiVersion = apiVersion;
    }

    static Profile fromMap(Map<String, dynamic> map) {
        return _fromDatabase(
            map["id"],
            map["serverAddress"],
            map["port"],
            map["glancesApiVersion"],
            map["caption"]
        );
    }

    /// Constructor for Profiles by the Database.
    static Profile _fromDatabase(int id, String serverAddress, String port, String apiVersion, String caption) {
        Profile profile = new Profile(serverAddress, port, caption, apiVersion);

        profile.id = id;

        return profile;
    }

    Map<String, dynamic> toMap() {
        return {
            "id" : this.id,
            "serverAddress" : this.serverAddress,
            "port" : this.port,
            "glancesApiVersion" : this.glancesApiVersion,
            "caption" : this.caption
        };
    }
}