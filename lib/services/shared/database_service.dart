import 'dart:async';
import 'dart:core';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:glutter/models/remote_control/command.dart';
import 'package:glutter/models/settings/settings.dart';
import 'package:glutter/models/shared/profile.dart';
import 'package:glutter/services/shared/database_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

/// Implements services to interact with the database.
class DatabaseService {
  /// Private Ctor -> Should not be instantiated.
  DatabaseService._();

  /// Public instance of the Service.
  static final DatabaseService db = DatabaseService._();

  /// Private instance of the SQLite-Database.
  static Database _database;

  /// SecureStorage for SSH-Passwords
  static final FlutterSecureStorage _storage = new FlutterSecureStorage();

  /// Getter for the database.
  Future<Database> get database async {
    if (_database != null) return _database;

    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  /// Initializes the database.
  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    /// Database-Path and Database-Name! Do not edit!
    String path = documentsDirectory.path + "glutter_1_1.db";

    return await openDatabase(path, version: 1, onOpen: (db) {}, onCreate: (Database db, int version) async {
      await db.execute(DatabaseProvider.createProfileTable());
      await db.execute(DatabaseProvider.createSettingsTable());
      await db.execute(DatabaseProvider.createCommandsTable());
    });
  }

  /// Inserts one profile into the database.
  Future<void> insertProfile(Profile profile) async {
    final Database db = await database;

    // Add sshPassword to secure storage
    String password = profile.sshPassword;
    await _storage.write(key: profile.caption, value: password);

    // Delete sshPassword from profile
    profile.sshPassword = '';

    await db.insert("profiles", profile.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  /// Loads all profiles from the database.
  Future<List<Profile>> getProfiles() async {
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.query('profiles');

    return List.generate(maps.length, (i) {
      return Profile.fromMap(maps[i]);
    });
  }

  /// Loads one profile by its ID.
  Future<Profile> getProfileById(int id) async {
    final db = await database;

    var res = await db.query("profiles", where: "id = ?", whereArgs: [id]);

    if (res.isNotEmpty) {
      // Adding sshPassword to profile from secure storage
      Profile profile = Profile.fromMap(res.first);
      String password = await _storage.read(key: profile.caption);
      profile.sshPassword = password;

      return profile;
    }

    return null;
  }

  /// Updates one profile, which already exists in the database.
  Future<void> updateProfile(Profile newProfile) async {
    final db = await database;

    var resOldProfile = await db.query("profiles", where: "id = ?", whereArgs: [newProfile.id]);
    String oldProfileCaption = Profile.fromMap(resOldProfile.first).caption;

    // Deletes the old entry in the secure storage and adds a new one (possible new caption)
    await _storage.delete(key: oldProfileCaption);
    await _storage.write(key: newProfile.caption, value: newProfile.sshPassword);

    var res = await db.update("profiles", newProfile.toMap(), where: "id = ?", whereArgs: [newProfile.id]);
    return res;
  }

  /// Deletes one profile by its ID from the database.
  Future<void> deleteProfileById(int id) async {
    final db = await database;

    var res = await db.query("profiles", where: "id = ?", whereArgs: [id]);
    Profile profile = Profile.fromMap(res.first);

    // Delete the old sshPassword in the secure storage
    _storage.delete(key: profile.caption);

    db.delete("profiles", where: "id = ?", whereArgs: [id]);
  }

  /// Deletes every profile in the database.
  Future<void> deleteAllProfiles() async {
    final db = await database;

    // Delete all entries in the secure storage
    _storage.deleteAll();

    db.rawDelete("Delete from profiles");
  }

  /// Deletes every settings-row in the database.
  Future<void> deleteAllSettings() async {
    final db = await database;

    db.rawDelete("Delete from settings");
  }

  /// Inserts one settings into the database and deletes any further settings-row.
  Future<void> insertSettings(Settings settings) async {
    final Database db = await database;

    /// We only can have one settings-Row!
    await this.deleteAllSettings();

    await db.insert("settings", settings.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  /// Loads the settings-rows from the database.
  Future<Settings> getSettings() async {
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.query('settings');

    // returns the first (and hopefully only) settings-object.
    return Settings.fromMap(maps[0]);
  }

  /// Updates one Settings-Row, which already exists in the database.
  Future<void> updateSettings(Settings newSettings) async {
    final db = await database;

    var res = await db.update("settings", newSettings.toMap(), where: "id = ?", whereArgs: [newSettings.id]);
    return res;
  }

  /// Inserts one Command into the database
  Future<void> insertCommand(Command command) async {
    final Database db = await database;

    db.insert('commands', command.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  /// Loads all Commands for every server
  Future<List<Command>> getCommands() async {
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.query('commands');

    return List.generate(maps.length, (i) {
      return Command.fromMap(maps[i]);
    });
  }

  /// Loads the Commands for one single server
  Future<List<Command>> getCommandsByProfileId(int profileId) async {
    final db = await database;

    var res = await db.query("commands", where: "profileId = ?", whereArgs: [profileId]);

    return List.generate(res.length, (i) {
      return Command.fromMap(res[i]);
    });
  }

  /// Loads one single command by its ID
  Future<Command> getCommandById(int id) async {
    final db = await database;

    var res = await db.query("commands", where: "id = ?", whereArgs: [id]);

    return Command.fromMap(res.first);
  }

  /// Updates one single command
  Future<void> updateCommand(Command newCommand) async {
    final db = await database;

    await db.update("commands", newCommand.toMap(), where: "id = ?", whereArgs: [newCommand.id]);
  }

  /// Deletes all Commands in the database
  Future<void> deleteAllCommands() async {
    final db = await database;

    db.rawDelete("Delete from commands");
  }

  /// Deletes one single Command by its ID
  Future<void> deleteCommandById(int id) async {
    final db = await database;

    db.delete("commands", where: "id = ?", whereArgs: [id]);
  }
}
