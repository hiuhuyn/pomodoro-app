import 'package:flutter/material.dart';
import 'package:pomodoro_focus/views/screens/statistics/statistics_screen.dart';
import 'package:pomodoro_focus/views/screens/task_management/task_management_screen.dart';
import 'package:pomodoro_focus/views/screens/task_management/task_management_screen_viewmodel.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int page = 0;
  @override
  void initState() {
    super.initState();
    context.read<TaskManagementScreenViewmodel>().fetchTasks(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                onPageChanged: (value) {
                  setState(() {
                    page = value;
                  });
                },
                children: const [
                  TaskManagementScreen(),
                  StatisticsScreen(),
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
