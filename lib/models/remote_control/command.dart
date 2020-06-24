/// Represents a SSH-Command
class Command {
    /// ID for Database
    int id;

    /// ID of the profile the command belongs to
    int profileId;

    /// The actual SSH-Command
    String commandMessage;

    /// Ctor for Commands
    Command(String msg) {
        this.commandMessage = msg;
    }

    /// Converts data from Database into Command.
    static Command fromMap(Map<String, dynamic> map) {
        return _fromDatabase(
            map["id"],
            map["profileId"],
            map["commandMessage"]
        );
    }

    /// Constructor for Commands by the Database.
    static Command _fromDatabase(int id, int profileId, String commandMessage) {
        Command cmd = new Command(commandMessage);

        cmd.id = id;
        cmd.profileId = profileId;

        return cmd;
    }

    /// Converts the object into a map for storing it into the database.
    Map<String, dynamic> toMap() {
        return {
            "id" : this.id,
            "profileId" : this.profileId,
            "commandMessage" : this.commandMessage
        };
    }
}