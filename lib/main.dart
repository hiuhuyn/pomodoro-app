import 'package:flutter/material.dart';
import 'package:pomodoro_focus/core/route/route_generate.dart';
import 'package:pomodoro_focus/core/route/route_name.dart';
import 'package:pomodoro_focus/set_up.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setup();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
    );
  }
}
