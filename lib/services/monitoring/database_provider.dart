/// Provides functions and constants for work with the database.
class DatabaseProvider {
    /// Provides the SQL-Script for creating the Profiles-Table.
    static String createProfileTable() {
        return
            "CREATE TABLE profiles ( " +
                "id	INTEGER NOT NULL PRIMARY KEY, " +
                "serverAddress TEXT NOT NULL, " +
                "port TEXT NOT NULL, " +
                "glancesApiVersion TEXT NOT NULL, " +
                "caption TEXT" +
            ");"
            ;
    }

    /// Provides the SQL-Script for creating the Profiles-Table.
    static String createSettingsTable() {
        return
            "CREATE TABLE settings ( " +
                "id	INTEGER NOT NULL PRIMARY KEY, " +
                "defaultProfileId INTEGER NOT NULL, " +
                "isDarkmode INTEGER NOT NULL" +
                ");"
        ;
    }
}