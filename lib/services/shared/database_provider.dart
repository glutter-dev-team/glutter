/// Provides functions and constants for work with the database.
class DatabaseProvider {
    /// Provides the SQL-Script for creating the Profiles-Table.
    static String createProfileTable() {
        return
            "CREATE TABLE profiles ( " +
                "id	INTEGER NOT NULL PRIMARY KEY, " +
                "serverAddress TEXT NOT NULL, " +
                "port INTEGER NOT NULL, " +
                "glancesApiVersion TEXT NOT NULL, " +
                "caption TEXT, " +
                "sshPort INTEGER, " +
                "sshUsername TEXT" +
            ");"
            ;
    }

    /// Provides the SQL-Script for creating the Settings-Table.
    static String createSettingsTable() {
        return
            "CREATE TABLE settings ( " +
                "id	INTEGER NOT NULL PRIMARY KEY, " +
                "defaultProfileId INTEGER NOT NULL, " +
                "isDarkmode INTEGER NOT NULL" +
                ");"
        ;
    }

    /// Provides the SQL-Script for creating the Commands-Table.
    static String createCommandsTable() {
        return
            "CREATE TABLE commands ( " +
                "id	INTEGER NOT NULL PRIMARY KEY, " +
                "profileId INTEGER NOT NULL, " +
                "commandMessage TEXT NOT NULL" +
                ");"
        ;
    }
}