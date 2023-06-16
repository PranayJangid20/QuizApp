import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;
  static final DatabaseHelper instance = DatabaseHelper._();

  DatabaseHelper._();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final path = await getDatabasesPath();
    final databasePath = join(path, 'prepaudScore.db');

    return openDatabase(
      databasePath,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  void _createDatabase(Database db, int version) async {
    await db.execute('CREATE TABLE score (time INTEGER PRIMARY KEY, score TEXT, actTime TEXT )');
    // Add more table creations or initial data setup if needed
  }

// Add your database operations here, such as insert, update, delete, and query methods
}
