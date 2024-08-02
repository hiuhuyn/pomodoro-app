import 'package:flutter/material.dart';

import '../../../model/task.dart';

class TaskScreen extends StatefulWidget {
  TaskScreen({super.key, this.task});
  Task? task;

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
