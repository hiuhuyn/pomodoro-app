import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pomodoro_focus/core/unit.dart';
import 'package:pomodoro_focus/repositorys/repository_local.dart';

import '../../../model/task.dart';
import 'chart/chart_week_statistics.dart';

class StatisticsScreenViewModel extends ChangeNotifier {
  TaskRepository taskRepository;
  StatisticsScreenViewModel(this.taskRepository);
  Widget _chartWeek = const Card();
  Widget _chartMonth = const Card();
  Widget _chartToday = const Card();
  Widget _allTime = const Card();

  Widget get chartWeek => _chartWeek;
  Widget get chartMonth => _chartMonth;
  Widget get chartToday => _chartToday;
  Widget get allTime => _allTime;

  void fetchData(DateTime date, BuildContext context) {
    updateChartToday(context);
    updateChartWeek(date, context);
    updateChartMonth(date, context);
  }

  void updateChartWeek(DateTime date, BuildContext context) async {
    final Map<int, double> focusTimePerDay = {
      for (var i = 1; i <= 7; i++) i: 0.0
    }; // từ thứ 2 đến chủ nhật
    final Map<int, int> completedTasksPerDay = {
      for (var i = 1; i <= 7; i++) i: 0
    };
    final Map<int, int> pendingTasksPerDay = {
      for (var i = 1; i <= 7; i++) i: 0
    };
    void calculateWeeklyStatistics(List<Task> tasks) {
      for (var task in tasks) {
        int weekday = task.startDate!.weekday;
        focusTimePerDay[weekday] =
            (focusTimePerDay[weekday] ?? 0) + task.focusTime;

        if (task.isCompleted) {
          completedTasksPerDay[weekday] =
              (completedTasksPerDay[weekday] ?? 0) + 1;
        } else {
          pendingTasksPerDay[weekday] = (pendingTasksPerDay[weekday] ?? 0) + 1;
        }
      }
    }

    try {
      final result = await taskRepository.getTasksByWeek(date);
      log(result.toString());
      calculateWeeklyStatistics(result);
      _chartWeek = Container(
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
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(formatDate(date, isYear: true)),
                IconButton(
                  onPressed: () {
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2023),
                      lastDate: DateTime(2050),
                      initialDatePickerMode: DatePickerMode.day,
                    ).then(
                      (value) {
                        if (value != null) {
                          updateChartWeek(value, context);
                        }
                      },
                    );
                  },
                  icon: const Icon(Icons.calendar_month_outlined),
                ),
              ],
            ),
            TaskStatisticsChart(
              title: "Thống kê công việc theo tuần",
              focusTimePerDay: focusTimePerDay,
              completedTasksPerDay: completedTasksPerDay,
              pendingTasksPerDay: pendingTasksPerDay,
            ),
          ],
        ),
      );
      notifyListeners();
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Could not fetch data from the server: $e'),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            )
          ],
        ),
      );
    }
  }

  void updateChartMonth(DateTime date, BuildContext context) async {
    notifyListeners();
  }

  void updateChartToday(BuildContext context) async {
    try {
      DateTime date = DateTime.now();
      final result = await taskRepository.getTasksByDate(date);
      int totalFocusTime = 0;
      int totalCompletedTasks = 0;
      int totalUncompletedTasks = 0;

      for (var i in result) {
        totalFocusTime += i.focusTime ?? 0;
        totalCompletedTasks += i.isCompleted ? 1 : 0;
        totalUncompletedTasks += i.isCompleted ? 0 : 1;
      }
      _chartToday = Container(
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hôm nay",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.blue[50],
                    ),
                    child: Column(
                      children: [
                        Text(
                          totalCompletedTasks.toString(),
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const Text(
                          'Đã hoàn thành',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.blue[50],
                    ),
                    child: Column(
                      children: [
                        Text(
                          totalUncompletedTasks.toString(),
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const Text(
                          'Chưa hoàn thành',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Text('Tập trung: $totalFocusTime phút'),
          ],
        ),
      );

      notifyListeners();
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text('Failed to fetch tasks: $e'),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        ),
      );
    }
  }
}
