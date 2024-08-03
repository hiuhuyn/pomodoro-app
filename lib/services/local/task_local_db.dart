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

  Future<List<Task>> getByStatus(bool status) async {
    final dbClient = await db;

    final List<Map<String, dynamic>> maps = await dbClient!.query(
      TABLE_NAME_TASK,
      where: 'isCompleted = ?',
      whereArgs: [status ? 1 : 0],
    );

    return List.generate(maps.length, (i) {
      return Task.fromMap(maps[i]);
    });
  }

  Future<Task?> getById(int id) async {
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

  Future<List<Task>> getByTitle(String title) async {
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
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    final List<Map<String, dynamic>> maps = await dbClient!.query(
      TABLE_NAME_TASK,
      where: 'startDate >= ? AND startDate <= ?',
      whereArgs: [
        startOfDay.millisecondsSinceEpoch,
        endOfDay.millisecondsSinceEpoch,
      ],
    );

    return List.generate(maps.length, (i) {
      return Task.fromMap(maps[i]);
    });
  }

  Future<List<Task>> getByWeek(DateTime week) async {
    final dbClient = await db;

    final startOfWeek = week.subtract(Duration(days: week.weekday - 1));
    final endOfWeek = startOfWeek
        .add(const Duration(days: 7, hours: 23, minutes: 59, seconds: 59));

    final List<Map<String, dynamic>> maps = await dbClient!.query(
      TABLE_NAME_TASK,
      where: 'startDate >= ? AND startDate <= ?',
      whereArgs: [
        startOfWeek.millisecondsSinceEpoch,
        endOfWeek.millisecondsSinceEpoch,
      ],
    );

    return List.generate(maps.length, (i) {
      return Task.fromMap(maps[i]);
    });
  }

  Future<List<Task>> getByMonth(DateTime month) async {
    final dbClient = await db;

    final startOfMonth = DateTime(month.year, month.month, 1);
    final endOfMonth = DateTime(month.year, month.month + 1, 0, 23, 59, 59);

    final List<Map<String, dynamic>> maps = await dbClient!.query(
      TABLE_NAME_TASK,
      where: 'startDate >= ? AND startDate <= ?',
      whereArgs: [
        startOfMonth.millisecondsSinceEpoch,
        endOfMonth.millisecondsSinceEpoch,
      ],
    );

    return List.generate(maps.length, (i) {
      return Task.fromMap(maps[i]);
    });
  }
}
