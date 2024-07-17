import 'package:flutter/material.dart';
import 'package:pomodoro_focus/pages/tasks_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: PageView(
          children: [
            TasksScreen(),
          ],
        ),
      ),
    );
  }
}
