/// Stores settings-information set by the user.
class Settings {
    /// ID of the current settings-Object.
    int id;

    /// ID of the current default-profile
    int defaultProfileId;

    /// Idicates, whether the user turned on darkmode.
    bool isDarkmode;

    /// Ctor of Settings.
    Settings(int defaultProfileId, bool isDarkmode) {
        this.defaultProfileId = defaultProfileId;
        this.isDarkmode = isDarkmode;
    }

    /// Creates a map from the Settings-Object. For storing the object in the database.
    Map<String, dynamic> toMap() {
        return {
            'defaultProfileId': this.defaultProfileId,
            'isDarkmode': this.isDarkmode
        };
    }

    /// Converts data from Database into Settings.
    static Settings fromMap(Map<String, dynamic> map) {
        return _fromDatabase(
            map["id"],
            map["defaultProfileId"],
            map["isDarkmode"]
        );
    }

    /// Constructor for Settings by the Database.
    static Settings _fromDatabase(int id, int defaultProfileId, int isDarkmode) {
        Settings settings = new Settings(defaultProfileId, true);

        settings.id = id;
        if (isDarkmode == 1) {
            settings.isDarkmode = true;
        }
        else {
            settings.isDarkmode = false;
        }

        return settings;
    }
}