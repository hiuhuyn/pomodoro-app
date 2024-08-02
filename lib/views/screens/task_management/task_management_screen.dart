import 'package:flutter/material.dart';
import '../../../model/task.dart';
import '../../widgets/item_build_list_task.dart';

class TaskManagementScreen extends StatefulWidget {
  const TaskManagementScreen({super.key});

  @override
  State<TaskManagementScreen> createState() => _TaskManagementScreenState();
}

class _TaskManagementScreenState extends State<TaskManagementScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ItemBuildListTask(
              title: "To days",
              items: [
                Task(
                  title: "Task 1",
                  startDate: DateTime.now(),
                  endDate: DateTime.now(),
                  isCompleted: true,
                ),
                Task(
                  title: "Task 1",
                  startDate: DateTime.now(),
                  endDate: DateTime.now(),
                  isCompleted: false,
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
