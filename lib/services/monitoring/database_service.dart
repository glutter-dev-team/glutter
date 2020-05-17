import 'dart:async';
import 'dart:io';
import 'dart:core';

import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:glutter/services/monitoring/database_provider.dart';
import 'package:glutter/models/monitoring/profile.dart';

/// Implements service to interact with the database.
class DatabaseService {

    DatabaseService._();

    static final DatabaseService db = DatabaseService._();

    static Database _database;

    /// Getter for the database.
    Future<Database> get database async {
        if (_database != null)
            return _database;

        // if _database is null we instantiate it
        _database = await initDB();
        return _database;
    }

    /// Initializes the database.
    initDB() async {
        Directory documentsDirectory = await getApplicationDocumentsDirectory();

        String path = documentsDirectory.path + "glutter.db";

        return await openDatabase(path, version: 1, onOpen: (db) {
        }, onCreate: (Database db, int version) async {
            await db.execute(DatabaseProvider.getOnCreate());
        });
    }

    /// Inserts one profile into the database.
    Future<void> insertProfile(Profile profile) async {
        final Database db = await database;

        await db.insert(
            "profiles",
            profile.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace
        );
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

        var res =await  db.query("profiles", where: "id = ?", whereArgs: [id]);

        return res.isNotEmpty ? Profile.fromMap(res.first) : Null ;
    }

    /// Updates one profile, which already exists in the database.
    updateProfile(Profile newProfile) async {
        final db = await database;

        var res = await db.update("profiles", newProfile.toMap(),
            where: "id = ?", whereArgs: [newProfile.id]);
        return res;
    }

    /// Deletes one profile by its ID from the database.
    deleteProfileById(int id) async {
        final db = await database;

        db.delete("profiles", where: "id = ?", whereArgs: [id]);
    }

    /// Deletes every profile in the database.
    deleteAllProfiles() async {
        final db = await database;

        db.rawDelete("Delete * from profiles");
    }
}
