import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class TaskStatisticsChart extends StatelessWidget {
  final Map<int, double> focusTimePerDay;
  final Map<int, int> completedTasksPerDay;
  final Map<int, int> pendingTasksPerDay;
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

  const TaskStatisticsChart(
      {super.key,
      required this.focusTimePerDay,
      required this.completedTasksPerDay,
      required this.pendingTasksPerDay,
      required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        _buildFocusTimeLineChart(),
        const SizedBox(height: 40),
        _buildTaskCompletionBarChart(),
      ],
    );
  }

  Widget _buildFocusTimeLineChart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Thời gian tập trung"),
        AspectRatio(
          aspectRatio: 1.5,
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

  Widget _buildTaskCompletionBarChart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Công việc hoàn thành và chưa hoàn thành"),
        AspectRatio(
          aspectRatio: 1,
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
