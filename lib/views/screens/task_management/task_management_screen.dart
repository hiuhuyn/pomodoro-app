import 'package:flutter/material.dart';
import 'package:pomodoro_focus/core/route/route_generate.dart';
import 'package:pomodoro_focus/views/screens/task_management/task_management_screen_viewmodel.dart';
import 'package:pomodoro_focus/views/widgets/task_item.dart';
import 'package:provider/provider.dart';

class TaskManagementScreen extends StatefulWidget {
  const TaskManagementScreen({super.key});

  @override
  State<TaskManagementScreen> createState() => _TaskManagementScreenState();
}

class _TaskManagementScreenState extends State<TaskManagementScreen> {
  int filterType = 0;
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
                  Text("Tìm kiếm..."),
                ],
              ),
            ),
          ),
          Row(
            children: [
              PopupMenuButton(
                icon: const Icon(Icons.filter_list_outlined),
                itemBuilder: (context) {
                  return [
                    const PopupMenuItem(
                      value: 0,
                      child: Text("Tất cả"),
                    ),
                    const PopupMenuItem(
                      value: 1,
                      child: Text("Chưa hoàn thành"),
                    ),
                    const PopupMenuItem(
                      value: 2,
                      child: Text("Đã hoàn thành"),
                    ),
                    const PopupMenuItem(
                      value: 3,
                      child: Text("Hôm nay"),
                    ),
                    const PopupMenuItem(
                      value: 4,
                      child: Text("Ngày mai"),
                    ),
                    const PopupMenuItem(
                      value: 5,
                      child: Text("Tuần này"),
                    ),
                    const PopupMenuItem(
                      value: 6,
                      child: Text("Tháng này"),
                    ),
                  ];
                },
                onSelected: (value) {
                  setState(() {
                    filterType = value;
                    context
                        .read<TaskManagementScreenViewmodel>()
                        .fetchTasks(context, filterType: filterType);
                  });
                },
              ),
              filterTypeWidget()
            ],
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () {
                return context
                    .read<TaskManagementScreenViewmodel>()
                    .fetchTasks(context, filterType: filterType);
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

  Widget filterTypeWidget() {
    String filterName = "Tất cả";
    switch (filterType) {
      case 0:
        filterName = "Tất cả";
        break;
      case 1:
        filterName = "Chưa hoàn thành";
        break;
      case 2:
        filterName = "Đã hoàn thành";
        break;
      case 3:
        filterName = "Hôm nay";
        break;
      case 4:
        filterName = "Ngày mai";
        break;
      case 5:
        filterName = "Tuần này";
        break;
      case 6:
        filterName = "Tháng này";
        break;
    }
    return Text(filterName);
  }
}
