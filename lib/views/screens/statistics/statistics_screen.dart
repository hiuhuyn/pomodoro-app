import 'package:flutter/material.dart';
import 'package:pomodoro_focus/views/screens/statistics/statistics_screen_viewmodel.dart';
import 'package:provider/provider.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context
        .read<StatisticsScreenViewModel>()
        .fetchData(DateTime.now(), context);
    return RefreshIndicator(
      onRefresh: () {
        return context
            .read<StatisticsScreenViewModel>()
            .fetchData(DateTime.now(), context);
      },
      child: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(8),
          child: Consumer<StatisticsScreenViewModel>(
            builder: (context, value, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Báo cáo thống kê",
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  value.allTime,
                  const SizedBox(
                    height: 20,
                  ),
                  value.chartToday,
                  const SizedBox(
                    height: 20,
                  ),
                  value.chartWeek,
                  const SizedBox(
                    height: 20,
                  ),
                  value.chartMonth,
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
