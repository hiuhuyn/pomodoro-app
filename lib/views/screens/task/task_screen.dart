import 'package:flutter/material.dart';
import 'package:pomodoro_focus/views/screens/task/add_edit_task_page.dart';
import 'package:pomodoro_focus/views/screens/task/management_todo_page.dart';
import 'package:pomodoro_focus/views/screens/task_management/task_management_screen_viewmodel.dart';
import 'package:provider/provider.dart';

import '../../../model/task.dart';

// ignore: must_be_immutable
class TaskScreen extends StatefulWidget {
  TaskScreen({super.key, this.task});
  Task? task;

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  late Task task;
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  @override
  void initState() {
    super.initState();
    task = widget.task ?? Task();
    if (task.id != null) {
      context
          .read<TaskManagementScreenViewmodel>()
          .findTodosByTask(context, task.id!)
          .then(
        (value) {
          setState(() {
            task.subTask = value;
          });
        },
      );
    }
    titleController.text = widget.task?.title ?? "";
    descriptionController.text = widget.task?.description ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(task.id == null ? 'Add Task' : 'Edit Task'),
        actions: [
          if (task.id != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                context
                    .read<TaskManagementScreenViewmodel>()
                    .deleteTask(context, task.id!);
              },
            ),
        ],
      ),
      body: PageView(
        children: [
          AddEditTaskPage(
            key: GlobalKey(),
            task: task,
            titleController: titleController,
            descriptionController: descriptionController,
          ),
          ManagementTodoPage(
            key: GlobalKey(),
            values: task.subTask,
            idTask: task.id,
          ),
        ],
      ),
    );
  }
}
