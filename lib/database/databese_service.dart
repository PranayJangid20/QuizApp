import 'database_helper.dart';

class DatabaseService {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  Future<void> insertScore(String score, String actTime) async {
    final db = await _databaseHelper.database;
    await db.insert('score', {'time':DateTime.now().millisecondsSinceEpoch,'score': score,'actTime':actTime});
  }

  Future<List<Map<String, dynamic>>> getScores() async {
    final db = await _databaseHelper.database;
    return db.query('score');
  }
}
