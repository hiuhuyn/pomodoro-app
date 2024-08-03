import 'package:pomodoro_focus/core/constants.dart';
import 'package:pomodoro_focus/model/todo.dart';
import 'package:sqflite/sqflite.dart';

import 'app_sqlite_db.dart';

class TodoLocalDB extends AppSqliteDb {
  Future<List<Todo>> getAll() async {
    final dbClient = await db;
    if (dbClient == null) return [];

    final List<Map<String, dynamic>> maps =
        await dbClient.query(TABLE_NAME_TODO);

    return List.generate(maps.length, (i) {
      return Todo.fromMap(maps[i]);
    });
  }

  Future<void> removeByTaskId(int taskId) async {
    final dbClient = await db;
    await dbClient!.delete(
      TABLE_NAME_TODO,
      where: 'idTask = ?',
      whereArgs: [taskId],
    );
  }

  Future<List<Todo>> getByTaskId(int id) async {
    final dbClient = await db;
    if (dbClient == null) return [];

    final List<Map<String, dynamic>> maps = await dbClient.query(
      TABLE_NAME_TODO,
      where: "idTask = ?",
      whereArgs: [id],
    );

    return List.generate(maps.length, (i) {
      return Todo.fromMap(maps[i]);
    });
  }

  Future<int> add(Todo todo) async {
    final dbClient = await db;
    if (dbClient == null) return -1;

    return await dbClient.insert(
      TABLE_NAME_TODO,
      todo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future update(Todo todo) async {
    final dbClient = await db;
    if (dbClient == null) return;

    await dbClient.update(
      TABLE_NAME_TODO,
      todo.toMap(),
      where: "id = ?",
      whereArgs: [todo.id],
    );
  }

  Future remove(int id) async {
    final dbClient = await db;
    if (dbClient == null) return;

    await dbClient.delete(
      TABLE_NAME_TODO,
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
