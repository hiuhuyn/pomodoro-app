import 'package:pomodoro_focus/model/todo.dart';
import 'package:sqflite/sqflite.dart';

class TodoLocalDB {
  static const String tableName = "todo";
  Database db;
  TodoLocalDB(this.db);
  Future<List<Todo>> getAll() async {
    return [];
  }

  Future<List<Todo>> getByTaskId(int id) async {
    return [];
  }

  Future<int> add(Todo todo) async {
    return -1;
  }

  Future update(Todo todo) async {}

  Future remove(int id) async {}
}
