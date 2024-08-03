import 'package:pomodoro_focus/core/constants.dart';
import '../../model/task.dart';
import 'app_sqlite_db.dart';

class TaskLocalDB extends AppSqliteDb {
  Future<int> add(Task task) async {
    final dbClient = await db;
    return await dbClient!.insert(TABLE_NAME_TASK, task.toMap());
  }

  Future update(Task task) async {
    final dbClient = await db;
    await dbClient!.update(
      TABLE_NAME_TASK,
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future remove(int id) async {
    final dbClient = await db;
    await dbClient!.delete(
      TABLE_NAME_TASK,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Task>> getAll() async {
    final dbClient = await db;

    final List<Map<String, dynamic>> maps =
        await dbClient!.query(TABLE_NAME_TASK);

    return List.generate(maps.length, (i) {
      return Task.fromMap(maps[i]);
    });
  }

  Future<Task?> findById(int id) async {
    final dbClient = await db;

    final List<Map<String, dynamic>> maps = await dbClient!.query(
      TABLE_NAME_TASK,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Task.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Task>> findByTitle(String title) async {
    final dbClient = await db;

    final List<Map<String, dynamic>> maps = await dbClient!.query(
      TABLE_NAME_TASK,
      where: 'title LIKE ?',
      whereArgs: ['%$title%'],
    );

    return List.generate(maps.length, (i) {
      return Task.fromMap(maps[i]);
    });
  }

  Future<List<Task>> getByDate(DateTime date) async {
    final dbClient = await db;

    final List<Map<String, dynamic>> maps = await dbClient!.query(
      TABLE_NAME_TASK,
      where: 'date(startDate) = ?',
      whereArgs: [date.toIso8601String().split('T')[0]],
    );

    return List.generate(maps.length, (i) {
      return Task.fromMap(maps[i]);
    });
  }

  Future<List<Task>> getByWeek(DateTime week) async {
    final dbClient = await db;

    final List<Map<String, dynamic>> maps = await dbClient!.rawQuery(
      'SELECT * FROM $TABLE_NAME_TASK WHERE strftime("%W", startDate) = strftime("%W", ?)',
      [week.toIso8601String()],
    );

    return List.generate(maps.length, (i) {
      return Task.fromMap(maps[i]);
    });
  }

  Future<List<Task>> getByMonth(DateTime month) async {
    final dbClient = await db;

    final List<Map<String, dynamic>> maps = await dbClient!.rawQuery(
      'SELECT * FROM $TABLE_NAME_TASK WHERE strftime("%m", startDate) = strftime("%m", ?)',
      [month.toIso8601String()],
    );

    return List.generate(maps.length, (i) {
      return Task.fromMap(maps[i]);
    });
  }
}
