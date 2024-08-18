import 'package:flutter/material.dart';
import 'package:pomodoro_focus/model/todo.dart';
import 'package:pomodoro_focus/repositorys/repository_local.dart';
import 'package:pomodoro_focus/services/notification_service.dart';

import '../../../model/task.dart';

class TaskManagementScreenViewmodel extends ChangeNotifier {
  TaskRepository taskRepository;
  TaskManagementScreenViewmodel(this.taskRepository);
  List<Task> _tasks = [];
  List<Task> get tasks {
    _tasks.sort((a, b) {
      if (a.startDate == null && b.startDate == null) {
        return 0; // Cả hai đều null
      } else if (a.startDate == null) {
        return 1; // Task a có startDate == null, xếp xuống cuối
      } else if (b.startDate == null) {
        return -1; // Task b có startDate == null, xếp xuống cuối
      } else {
        return a.startDate!.compareTo(b.startDate!); // So sánh startDate
      }
    });
    return _tasks;
  }

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

  Future fetchTasks(BuildContext context, {int filterType = 0}) async {
    try {
      switch (filterType) {
        case 0:
          _tasks = await taskRepository.getAllTasks();
          break;
        case 1:
          // chưa hoàn thành
          _tasks = await taskRepository.getTasksByStatus(false);
          break;
        case 2:
          // đã hoàn thành
          _tasks = await taskRepository.getTasksByStatus(true);
          break;
        case 3:
          // hôm nay
          _tasks = await taskRepository.getTasksByDate(DateTime.now());
          break;
        case 4:
          // ngày mai
          DateTime now = DateTime.now();
          DateTime tomorrow = now.copyWith(day: now.day + 1);
          _tasks = await taskRepository.getTasksByDate(tomorrow);
          break;
        case 5:
          // tuần này
          _tasks = await taskRepository.getTasksByWeek(DateTime.now());
          break;
        case 6:
          // tháng này
          _tasks = await taskRepository.getTasksByMonth(DateTime.now());
          break;
      }
      for (var element in _tasks) {
        NotificationService.cancelNotification(element.id!);
        if (element.startDate != null) {
          NotificationService.scheduleNotification(
            id: element.id!,
            body: element.title ?? "",
            scheduledTime: element.startDate!.copyWith(second: 0),
          );
        }
      }
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
      int index = _tasks.indexWhere(
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
      _tasks.add(task);
      NotificationService.cancelNotification(task.id!);
      if (task.startDate != null) {
        NotificationService.scheduleNotification(
          id: task.id!,
          body: task.title ?? "",
          scheduledTime: task.startDate!.copyWith(second: 0),
        );
      }
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
      int index = _tasks.indexWhere(
        (element) => element.id == task.id,
      );
      _tasks[index] = task;
      NotificationService.cancelNotification(task.id!);
      if (task.startDate != null) {
        NotificationService.scheduleNotification(
          id: task.id!,
          body: task.title ?? "",
          scheduledTime: task.startDate!.copyWith(second: 0),
        );
      }
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
      _tasks = _tasks
          .map((task) => task.id == taskId
              ? task.copyWith(isCompleted: !task.isCompleted)
              : task)
          .toList();
      await taskRepository
          .updateTask(_tasks.firstWhere((task) => task.id == taskId));
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
                        _tasks =
                            _tasks.where((task) => task.id != taskId).toList();
                        await taskRepository.removeTask(taskId);
                        NotificationService.cancelNotification(taskId);
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

  Future searchTaskByTitle(BuildContext context, String query) async {
    try {
      _tasks = await taskRepository.getTasksByTitle(query);
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
