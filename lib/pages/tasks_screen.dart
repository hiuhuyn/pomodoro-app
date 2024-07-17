import 'package:flutter/material.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextFormField(
              decoration: const InputDecoration(hintText: "Tìm kiếm"),
            ),
            _itemBuild(
                titile: "To days",
                items: ["Task 1", "Task 2", "Task 3", "Task 4", "Task 5"]),
            _itemBuild(
                titile: "Tomorrow",
                items: ["Task 1", "Task 2", "Task 3", "Task 4", "Task 5"]),
            _itemBuild(
                titile: "This week",
                items: ["Task 1", "Task 2", "Task 3", "Task 4", "Task 5"]),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _itemBuild({required String titile, required List<String> items}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          Row(
            children: [
              Text(titile),
              IconButton(
                icon: const Icon(Icons.arrow_drop_down_circle),
                onPressed: () {},
              ),
            ],
          ),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: items.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Wrap(
                  children: [
                    Icon(
                      // Icons.check_circle_outline,
                      Icons.circle_outlined,
                    ),
                    SizedBox(width: 4),
                    Icon(
                      // Icons.circle_outlined,
                      Icons.play_circle_outlined,
                    ),
                  ],
                ),
                onTap: () {},
                title: Text(items[index]),
              );
            },
          )
        ],
      ),
    );
  }
}
