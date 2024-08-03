import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pomodoro_focus/core/route/route_generate.dart';
import 'package:pomodoro_focus/views/screens/task_management/task_management_screen_viewmodel.dart';
import 'package:pomodoro_focus/views/widgets/task_item.dart';
import '../../../model/task.dart';
import 'package:provider/provider.dart';

class TaskManagementScreen extends StatefulWidget {
  const TaskManagementScreen({super.key});

  @override
  State<TaskManagementScreen> createState() => _TaskManagementScreenState();
}

class _TaskManagementScreenState extends State<TaskManagementScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              RouteGenerate.navigatorSearch(context);
            },
            child: Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 2,
                      spreadRadius: 1,
                    )
                  ]),
              child: const Row(
                children: [
                  Icon(Icons.search),
                  SizedBox(
                    width: 10,
                  ),
                  Text("Search..."),
                ],
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () {
                log("onRefresh");
                return context
                    .read<TaskManagementScreenViewmodel>()
                    .fetchTasks(context);
              },
              child: Consumer<TaskManagementScreenViewmodel>(
                builder: (context, value, child) {
                  if (value.tasks.isEmpty) {
                    return const Center(
                        child: Text("Không có công việc nào hiện tại"));
                  }
                  return ListView.builder(
                    itemCount: value.tasks.length,
                    itemBuilder: (context, index) {
                      return TaskItem(
                        task: value.tasks[index],
                        onTap: (task) {
                          RouteGenerate.navigatorEditTask(context, task);
                        },
                      );
                    },
                  );
                },
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          RouteGenerate.navigatorAddTask(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
