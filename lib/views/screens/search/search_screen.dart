import 'package:flutter/material.dart';
import 'package:pomodoro_focus/views/screens/task_management/task_management_screen_viewmodel.dart';
import 'package:pomodoro_focus/views/widgets/task_item.dart';
import 'package:provider/provider.dart';

import '../../../core/route/route_generate.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final textSearchCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                        context
                            .read<TaskManagementScreenViewmodel>()
                            .fetchTasks(context);
                      },
                      icon: const Icon(Icons.arrow_back_ios)),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 3,
                              spreadRadius: 1,
                            )
                          ]),
                      child: TextFormField(
                        autofocus: true,
                        maxLines: 1,
                        controller: textSearchCtrl,
                        onChanged: (value) {
                          context
                              .read<TaskManagementScreenViewmodel>()
                              .searchTaskByTitle(context, value);
                        },
                        decoration: const InputDecoration(
                          hintText: 'Nhập tên công việc...',
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Consumer<TaskManagementScreenViewmodel>(
                    builder: (context, value, child) {
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
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
