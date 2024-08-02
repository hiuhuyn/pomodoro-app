import 'package:flutter/material.dart';
import 'package:pomodoro_focus/core/route/route_name.dart';
import 'package:pomodoro_focus/views/screens/home/home_screen.dart';
import 'package:pomodoro_focus/views/screens/pomofocus/pomofocus_page.dart';
import 'package:pomodoro_focus/views/screens/search/search_screen.dart';
import 'package:pomodoro_focus/views/screens/task/task_screen.dart';

import '../../model/task.dart';

class RouteGenerate {
  static PageRoute generate(RouteSettings settings) {
    try {
      switch (settings.name) {
        case RouteName.home:
          return MaterialPageRoute(builder: (context) => const HomeScreen());
        case RouteName.pomodocus:
          return MaterialPageRoute(
              builder: (context) => const PomofocusScreen());
        case RouteName.search:
          return MaterialPageRoute(builder: (context) => const SearchScreen());
        case RouteName.addTask:
          return MaterialPageRoute(builder: (context) => TaskScreen());
        case RouteName.editTask:
          final arguments = settings.arguments! as Map<String, dynamic>;
          Task task = arguments['task'];
          return MaterialPageRoute(
              builder: (context) => TaskScreen(task: task));
        default:
          return MaterialPageRoute(
              builder: (context) => const HomeScreen(), settings: settings);
      }
    } catch (e) {
      return MaterialPageRoute(
          builder: (context) => const HomeScreen(), settings: settings);
    }
  }

  static void navigatorPomofocus(BuildContext context, {required Task task}) {
    Navigator.pushNamed(context, RouteName.pomodocus);
  }

  static void navigatorHome(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      RouteName.home,
      (route) {
        return false;
      },
    );
  }

  static void navigatorSearch(BuildContext context) {
    Navigator.pushNamed(
      context,
      RouteName.search,
    );
  }

  static void navigatorEditTask(BuildContext context, Task task) {
    Navigator.pushNamed(
      context,
      RouteName.editTask,
      arguments: {'task': task},
    );
  }

  static void navigatorAddTask(BuildContext context) {
    Navigator.pushNamed(
      context,
      RouteName.addTask,
    );
  }
}
