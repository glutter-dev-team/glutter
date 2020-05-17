/// Provides functions and constants for work with the database.
class DatabaseProvider {
    /// Provides the SQL-Script for OnCreate-Event of the database.
    static String getOnCreate() {
        return
            "CREATE TABLE profiles ( " +
                "id	INTEGER NOT NULL PRIMARY KEY, " +
                "serverAddress TEXT NOT NULL, " +
                "port TEXT NOT NULL, " +
                "glancesApiVersion TEXT NOT NULL, " +
                "caption TEXT" +
            ");";
    }
}