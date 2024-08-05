import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pomodoro_focus/repositorys/repository_local.dart';
import 'package:pomodoro_focus/services/local/task_local_db.dart';
import 'package:pomodoro_focus/services/local/todo_local_db.dart';
import 'package:pomodoro_focus/services/notification_service.dart';
import 'package:timezone/data/latest.dart' as tz;

final getIt = GetIt.instance;

Future setup() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();
  tz.initializeTimeZones();
  getIt.registerLazySingleton<TaskRepository>(
    () =>
        TaskRepository(taskLocalDB: TaskLocalDB(), todoLocalDB: TodoLocalDB()),
  );
}
