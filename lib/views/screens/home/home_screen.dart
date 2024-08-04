import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:pomodoro_focus/views/screens/statistics_screen/statistics_screen.dart';
import 'package:pomodoro_focus/views/screens/task_management/task_management_screen.dart';
import 'package:pomodoro_focus/views/screens/task_management/task_management_screen_viewmodel.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _pageController = PageController();
  // final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    context.read<TaskManagementScreenViewmodel>().fetchTasks(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView(
          // onPageChanged: (value) {
          //   final CurvedNavigationBarState? navBarState =
          //       _bottomNavigationKey.currentState;
          //   navBarState?.setPage(value);
          // },
          controller: _pageController,
          children: const [
            TaskManagementScreen(),
            StatisticsScreen(),
          ],
        ),
      ),
      // bottomNavigationBar: CurvedNavigationBar(
      //   key: _bottomNavigationKey,
      //   backgroundColor: Colors.white,
      //   items: const [
      //     Icon(Icons.list_sharp, size: 30),
      //     Icon(Icons.bar_chart_sharp, size: 30),
      //   ],
      //   animationDuration: const Duration(milliseconds: 200),
      //   onTap: (index) {
      //     _pageController.animateToPage(index,
      //         duration: const Duration(milliseconds: 200),
      //         curve: Curves.linear);
      //   },
      // ),
    );
  }
}
