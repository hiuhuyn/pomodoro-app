import 'package:flutter/material.dart';
import 'package:pomodoro_focus/core/route/route_generate.dart';
import 'package:pomodoro_focus/core/route/route_name.dart';
import 'package:pomodoro_focus/repositorys/repository_local.dart';
import 'package:pomodoro_focus/set_up.dart';
import 'package:provider/provider.dart';

import 'views/screens/task_management/task_management_screen_viewmodel.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setup();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) =>
                TaskManagementScreenViewmodel(getIt<TaskRepository>())),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            primary: Colors.blue,
          ),
          useMaterial3: true,
          scaffoldBackgroundColor: Colors.white,
        ),
        onGenerateRoute: RouteGenerate.generate,
        initialRoute: RouteName.home,
      ),
    );
  }
}
