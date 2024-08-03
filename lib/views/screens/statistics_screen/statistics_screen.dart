import 'package:flutter/material.dart';
import 'package:pomodoro_focus/views/screens/statistics_screen/chart/chart_week_statistics.dart';
import 'package:pomodoro_focus/views/screens/statistics_screen/statistics_screen_viewmodel.dart';
import 'package:provider/provider.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context
        .read<StatisticsScreenViewModel>()
        .fetchData(DateTime.now(), context);
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Consumer<StatisticsScreenViewModel>(
          builder: (context, value, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                value.chartToday,
                const SizedBox(
                  height: 20,
                ),
                value.chartWeek,
              ],
            );
          },
        ),
      ),
    );
  }
}
