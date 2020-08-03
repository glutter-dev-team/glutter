/// Stores settings-information set by the user.
class Settings {
    /// ID of the current settings-Object.
    int id;

    /// ID of the current default-profile
    int defaultProfileId;

    /// Idicates, whether the user turned on darkmode.
    bool isDarkmode;

    /// Ctor of Settings.
    Settings(int defaultProfileId) {
        this.defaultProfileId = defaultProfileId;
    }

    /// Creates a map from the Settings-Object. For storing the object in the database.
    Map<String, dynamic> toMap() {
        return {
            'defaultProfileId': this.defaultProfileId
        };
    }

    /// Converts data from Database into Settings.
    static Settings fromMap(Map<String, dynamic> map) {
        return _fromDatabase(
            map["id"],
            map["defaultProfileId"]
        );
    }

    /// Constructor for Settings by the Database.
    static Settings _fromDatabase(int id, int defaultProfileId) {
        Settings settings = new Settings(defaultProfileId);

        settings.id = id;

        return settings;
    }
}