import 'package:flutter/material.dart';
import 'package:pomodoro_focus/model/todo.dart';
import 'package:pomodoro_focus/repositorys/repository_local.dart';

import '../../../model/task.dart';

class TaskManagementScreenViewmodel extends ChangeNotifier {
  TaskRepository taskRepository;
  TaskManagementScreenViewmodel(this.taskRepository);
  List<Task> tasks = [];
  Future<List<Todo>> findTodosByTask(BuildContext context, int idTask) async {
    try {
      return await taskRepository.getTodoByTaskId(idTask);
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text('Lỗi tìm nhiệm vụ cho công việc.\n$e'),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
      return [];
    }
  }

  Future fetchTasks(BuildContext context) async {
    try {
      tasks = await taskRepository.getAllTasks();
      notifyListeners();
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text('Lấy dữ liệu thất bại. Vui lòng thử lại.\n$e'),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    }
  }

  Future saveTask(BuildContext context, Task task) async {
    try {
      int index = tasks.indexWhere(
        (element) => element.id == task.id,
      );
      if (index == -1) {
        _addTask(context, task);
      } else {
        _updateTask(context, task);
      }
      notifyListeners();
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text('Lưu thất bại. Vui lòng thử lại.\n$e'),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    }
  }

  Future<void> _addTask(BuildContext context, Task task) async {
    try {
      int id = await taskRepository.addTask(task);
      task.id = id;
      tasks.add(task);
      notifyListeners();
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text('Thêm mới thất bại. Vui lòng thử lại.\n$e'),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    }
  }

  Future<void> _updateTask(BuildContext context, Task task) async {
    try {
      await taskRepository.updateTask(task);
      int index = tasks.indexWhere(
        (element) => element.id == task.id,
      );
      tasks[index] = task;
      notifyListeners();
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text('Cập nhật thất bại. Vui lòng thử lại.\n$e'),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    }
  }

  Future<void> toggleTaskCompletion(BuildContext context, int taskId) async {
    try {
      tasks = tasks
          .map((task) => task.id == taskId
              ? task.copyWith(isCompleted: !task.isCompleted!)
              : task)
          .toList();
      await taskRepository
          .updateTask(tasks.firstWhere((task) => task.id == taskId));
      notifyListeners();
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text('Cập nhật thất bại. Vui lòng thử lại.\n$e'),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    }
  }

  Future<void> deleteTask(BuildContext context, int taskId) async {
    try {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                  title: const Text("Bạn có chắc muốn xóa công việc này?"),
                  content: const Text(
                      "Xóa thông tin công việc này sẽ không thể hoàn tác lại."),
                  actions: [
                    ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        tasks =
                            tasks.where((task) => task.id != taskId).toList();
                        await taskRepository.removeTask(taskId);
                        notifyListeners();
                        // ignore: use_build_context_synchronously
                        Navigator.pop(context);
                      },
                      child: const Text("Xóa"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Hủy"),
                    ),
                  ]));
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text('Failed to delete task. Please try again.\n$e'),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    }
  }
  Future searchTaskByTitle(BuildContext context, String query) async{
    try {
      tasks = await taskRepository.findTasksByTitle(query);
      notifyListeners();
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text('Failed to search tasks. Please try again.\n$e'),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    }
  }
}
