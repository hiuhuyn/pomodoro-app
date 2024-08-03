
import 'package:get_it/get_it.dart';
import 'package:pomodoro_focus/repositorys/repository_local.dart';
import 'package:pomodoro_focus/services/local/task_local_db.dart';
import 'package:pomodoro_focus/services/local/todo_local_db.dart';

final getIt = GetIt.instance;

Future setup() async {
  getIt.registerLazySingleton<TaskRepository>(
    () =>
        TaskRepository(taskLocalDB: TaskLocalDB(), todoLocalDB: TodoLocalDB()),
  );
}
