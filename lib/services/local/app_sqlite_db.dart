import 'package:pomodoro_focus/core/constants.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppSqliteDb {
  Database? _db;

  Future<void> initDB() async {
    _db = await openDatabase(
      join(await getDatabasesPath(), 'todo_database.db'),
      onCreate: (db, version) {
        db.execute(
          '''CREATE TABLE $TABLE_NAME_TASK(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            description TEXT,
            isCompleted INTEGER,
            repeatType TEXT,
            repeatDaysOfWeek TEXT,
            repeatDayOfMonth INTEGER,
            startDate INTEGER,
            endDate INTEGER,
            focusTime INTEGER,
            goalTime INTEGER
          )''',
        );
        db.execute(
          "CREATE TABLE $TABLE_NAME_TODO(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, completed INTEGER, idTask INTEGER)",
        );
      },
      version: 1,
    );
  }

  Future<Database?> get db async {
    if (_db == null) {
      await initDB();
    }
    return _db;
  }
}
