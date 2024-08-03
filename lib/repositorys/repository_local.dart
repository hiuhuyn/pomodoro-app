import 'package:pomodoro_focus/core/constants.dart';

import '../model/task.dart';
import '../model/todo.dart';
import '../services/local/task_local_db.dart';
import '../services/local/todo_local_db.dart';

class TaskRepository {
  final TaskLocalDB taskLocalDB;
  final TodoLocalDB todoLocalDB;

  TaskRepository({
     required this.taskLocalDB,
    required this.todoLocalDB,
  });

  Future<int> addTask(Task task) async {
    int taskId = await taskLocalDB.add(task);
    for (Todo todo in task.subTask) {
      todo.idTask = taskId;
      await todoLocalDB.add(todo);
    }
    return taskId;
  }

  Future<void> updateTask(Task task) async {
    await taskLocalDB.update(task);

    // Lấy danh sách hiện tại các subTask từ cơ sở dữ liệu
    List<Todo> currentSubTasks = await todoLocalDB.getByTaskId(task.id!);

    // Tạo danh sách id các subTask hiện tại trong cơ sở dữ liệu
    Set<int?> currentSubTaskIds =
        currentSubTasks.map((todo) => todo.id).toSet();

    // Tạo danh sách id các subTask mới từ task
    Set<int?> newSubTaskIds = task.subTask.map((todo) => todo.id).toSet();

    // Xóa các subTask không còn trong danh sách subTask mới
    for (Todo currentTodo in currentSubTasks) {
      if (!newSubTaskIds.contains(currentTodo.id)) {
        await todoLocalDB.remove(currentTodo.id!);
      }
    }

    // Thêm hoặc cập nhật các subTask mới
    for (Todo newTodo in task.subTask) {
      newTodo.idTask = task.id;
      if (currentSubTaskIds.contains(newTodo.id)) {
        // Cập nhật subTask hiện tại
        await todoLocalDB.update(newTodo);
      } else {
        // Thêm subTask mới
        await todoLocalDB.add(newTodo);
      }
    }
  }

  Future<void> removeTask(int taskId) async {
    await taskLocalDB.remove(taskId);
    await todoLocalDB.removeByTaskId(taskId);
  }

  Future<List<Task>> getAllTasks() async {
    return await taskLocalDB.getAll();
  }

  Future<Task?> findTaskById(int id) async {
    Task? task = await taskLocalDB.findById(id);
    if (task != null) {
      task.subTask = await todoLocalDB.getByTaskId(id);
    }
    return task;
  }

  Future<List<Task>> findTasksByTitle(String title) async {
    return await taskLocalDB.findByTitle(title);
  }

  Future<List<Task>> getTasksByDate(DateTime date) async {
    return await taskLocalDB.getByDate(date);
  }

  Future<List<Task>> getTasksByWeek(DateTime week) async {
    return await taskLocalDB.getByWeek(week);
  }

  Future<List<Task>> getTasksByMonth(DateTime month) async {
    return await taskLocalDB.getByMonth(month);
  }

  Future updateTodo(Todo todo) async {
    await todoLocalDB.update(todo);
  }

  Future<List<Todo>> getTodoByTaskId(int id) async {
    return await todoLocalDB.getByTaskId(id);
  }
}
