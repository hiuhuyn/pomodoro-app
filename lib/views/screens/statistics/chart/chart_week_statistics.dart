import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pomodoro_focus/core/unit.dart';
import 'package:pomodoro_focus/views/screens/statistics/statistics_screen_viewmodel.dart';
import 'package:provider/provider.dart';

class ChartWeekStatisticsWidget extends StatelessWidget {
  final Map<int, double> focusTimePerDay;
  final Map<int, int> completedTasksPerDay;
  final Map<int, int> pendingTasksPerDay;
  final DateTime date;
  final String title;
  int getMaxTasksInADay(
      Map<int, int> completedTasksPerDay, Map<int, int> pendingTasksPerDay) {
    int maxTasks = 0;

    for (int day = 1; day <= 7; day++) {
      int completedTasks = completedTasksPerDay[day] ?? 0;
      int pendingTasks = pendingTasksPerDay[day] ?? 0;
      int totalTasks = completedTasks + pendingTasks;

      if (totalTasks > maxTasks) {
        maxTasks = totalTasks;
      }
    }

    return maxTasks;
  }

  double getMaxFocusTimePerDay(Map<int, double> focusTimePerDay) {
    double maxFocusTime = 0.0;

    for (var time in focusTimePerDay.values) {
      if (time > maxFocusTime) {
        maxFocusTime = time;
      }
    }

    return maxFocusTime;
  }

  const ChartWeekStatisticsWidget({
    super.key,
    required this.focusTimePerDay,
    required this.completedTasksPerDay,
    required this.pendingTasksPerDay,
    required this.title,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              offset: const Offset(2.0, 2.0),
              color: Colors.black.withOpacity(0.2),
              blurRadius: 2.0,
            ),
            BoxShadow(
              offset: const Offset(-2.0, -2.0),
              color: Colors.black.withOpacity(0.2),
              blurRadius: 2.0,
            ),
          ]),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    formatDate(date, isYear: true),
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () {
                      showDatePicker(
                        context: context,
                        initialDate: date,
                        firstDate: DateTime(2023),
                        lastDate: DateTime(2050),
                        initialDatePickerMode: DatePickerMode.day,
                      ).then(
                        (value) {
                          if (value != null) {
                            context
                                .read<StatisticsScreenViewModel>()
                                .updateChartWeek(value, context);
                          }
                        },
                      );
                    },
                    icon: const Icon(Icons.calendar_month_outlined),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          buildFocusTimeLineChart(context),
          const SizedBox(height: 20),
          buildTaskCompletionBarChart(context),
        ],
      ),
    );
  }

  Widget buildFocusTimeLineChart(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Thời gian tập trung",
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        AspectRatio(
          aspectRatio: 2,
          child: LineChart(
            LineChartData(
              maxY: getMaxFocusTimePerDay(focusTimePerDay),
              lineBarsData: _buildFocusTimeLineBarData(),
              titlesData: _buildTitles(),
              gridData: const FlGridData(show: true),
              borderData: FlBorderData(show: true),
              lineTouchData: const LineTouchData(enabled: true),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildTaskCompletionBarChart(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Công việc hoàn thành và chưa hoàn thành",
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        AspectRatio(
          aspectRatio: 2,
          child: BarChart(
            BarChartData(
              maxY: getMaxTasksInADay(completedTasksPerDay, pendingTasksPerDay)
                  .toDouble(),
              barGroups: _buildTaskCompletionBarGroups(),
              borderData: FlBorderData(show: true),
              titlesData: _buildTitles(),
              barTouchData: BarTouchData(enabled: true),
              gridData: const FlGridData(show: true),
            ),
          ),
        ),
        Row(
          children: [
            Container(
              width: 10,
              height: 10,
              color: Colors.green,
              margin: const EdgeInsets.symmetric(horizontal: 15),
            ),
            const Text('Hoàn thành'),
            Container(
              width: 10,
              height: 10,
              color: Colors.red,
              margin: const EdgeInsets.symmetric(horizontal: 15),
            ),
            const Text('Chưa hoàn thành'),
          ],
        )
      ],
    );
  }

  List<LineChartBarData> _buildFocusTimeLineBarData() {
    List<FlSpot> spots = focusTimePerDay.entries
        .map((entry) => FlSpot(entry.key.toDouble(), entry.value))
        .toList();
    return [
      LineChartBarData(
        spots: spots,
        isCurved: false,
        color: Colors.blue,
        barWidth: 4,
        belowBarData:
            BarAreaData(show: true, color: Colors.blue.withOpacity(0.3)),
        dotData: const FlDotData(show: true),
      ),
    ];
  }

  List<BarChartGroupData> _buildTaskCompletionBarGroups() {
    return List.generate(7, (index) {
      int day = index + 1;
      return BarChartGroupData(
        x: day,
        barRods: [
          BarChartRodData(
            toY: (completedTasksPerDay[day]?.toDouble() ?? 0.0),
            color: Colors.green,
            width: 10,
          ),
          BarChartRodData(
            toY: (pendingTasksPerDay[day]?.toDouble() ?? 0.0),
            color: Colors.red,
            width: 10,
          ),
        ],
      );
    });
  }

  FlTitlesData _buildTitles() {
    return FlTitlesData(
      show: true,
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 28,
          getTitlesWidget: (double value, TitleMeta meta) {
            const style = TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            );
            switch (value.toInt()) {
              case 1:
                return const Text('Mon', style: style);
              case 2:
                return const Text('Tue', style: style);
              case 3:
                return const Text('Wed', style: style);
              case 4:
                return const Text('Thu', style: style);
              case 5:
                return const Text('Fri', style: style);
              case 6:
                return const Text('Sat', style: style);
              case 7:
                return const Text('Sun', style: style);
              default:
                return Container();
            }
          },
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 40,
          interval: 10,
          getTitlesWidget: (double value, TitleMeta meta) {
            const style = TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            );
            return Text(value.toString(), style: style);
          },
        ),
      ),
    );
  }
}
