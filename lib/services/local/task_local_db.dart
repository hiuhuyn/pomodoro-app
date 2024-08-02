import '../../model/task.dart';
import 'package:sqflite/sqflite.dart';

class TaskLocalDB {
  static const String tableName = "task";
  Database db;
  TaskLocalDB(this.db);
  Future<int> add(Task task) async {
    return -1;
  }

  Future update(Task task) async {}
  Future remove(Task task) async {}
  Future<List<Task>> getAll() async {
    return [];
  }

  Future<Task?> findById(int id) async {
    return null;
  }

  Future<List<Task>> findByTitle(String title) async {
    return [];
  }

  Future<List<Task>> getByDate(DateTime date) async {
    return [];
  }

  Future<List<Task>> getByWeek(DateTime week) async {
    return [];
  }

  Future<List<Task>> getByMonth(DateTime month) async {
    return [];
  }
}
