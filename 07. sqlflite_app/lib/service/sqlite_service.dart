import 'package:sqflite/sqflite.dart';
import 'package:sqlflite_app/model/profile.dart';

class SqliteService {
  static const String _databaseName = 'profilelist.db';
  static const String _tableName = 'profile';
  static const int _version = 1;

  Future<void> createTables(Database database) async {
    await database.execute(
      """CREATE TABLE $_tableName(
       id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
       name TEXT,
       email TEXT,
       phoneNumber TEXT,
       maritalStatus INTEGER
     )
     """,
    );
  }

  Future<Database> _initializeDb() async {
    return openDatabase(
      _databaseName,
      version: _version,
      onCreate: (Database database, int version) async {
        await createTables(database);
      },
    );
  }

  Future<int> insertItem(Profile profile) async {
    final db = await _initializeDb();

    final data = profile.toJson();
    final id = await db.insert(
      _tableName,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  Future<List<Profile>> getAllItems() async {
    final db = await _initializeDb();
    final results = await db.query(_tableName, orderBy: "id");

    return results.map((result) => Profile.fromJson(result)).toList();
  }

  Future<Profile> getItemById(int id) async {
    final db = await _initializeDb();
    final results =
        await db.query(_tableName, where: "id = ?", whereArgs: [id], limit: 1);

    return results.map((result) => Profile.fromJson(result)).first;
  }

  Future<int> updateItem(int id, Profile profile) async {
    final db = await _initializeDb();

    final data = profile.toJson();

    final result =
        await db.update(_tableName, data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  Future<int> removeItem(int id) async {
    final db = await _initializeDb();

    final result =
        await db.delete(_tableName, where: "id = ?", whereArgs: [id]);
    return result;
  }
}
