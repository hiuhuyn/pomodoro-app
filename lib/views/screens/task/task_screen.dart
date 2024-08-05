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
  final goalController = TextEditingController();

  int page = 0;
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
    goalController.text = widget.task?.goalTime.toString() ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: PageView(
                onPageChanged: (value) {
                  setState(() {
                    page = value;
                  });
                },
                children: [
                  AddEditTaskPage(
                    key: GlobalKey(),
                    task: task,
                    titleController: titleController,
                    descriptionController: descriptionController,
                    goalController: goalController,
                  ),
                  ManagementTodoPage(
                    key: GlobalKey(),
                    values: task.subTask,
                    idTask: task.id,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                      child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: page == 0 ? Colors.blue : Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: page == 0 ? Colors.blue : Colors.grey,
                              blurRadius: 2,
                              spreadRadius: 1,
                              offset: const Offset(0, 2))
                        ]),
                    height: 10,
                  )),
                  Expanded(
                      child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: page == 1 ? Colors.blue : Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: page == 1 ? Colors.blue : Colors.grey,
                              blurRadius: 2,
                              spreadRadius: 1,
                              offset: const Offset(0, 2))
                        ]),
                    height: 10,
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
