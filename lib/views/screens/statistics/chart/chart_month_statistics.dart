import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:provider/provider.dart';
import '../../../../model/task.dart';
import '../statistics_screen_viewmodel.dart';

class ChartMonthStatisticsWidget extends StatelessWidget {
  ChartMonthStatisticsWidget(
      {super.key, required this.month, required this.tasks});
  DateTime month;
  List<Task> tasks;

  DateTime startMonth = DateTime.now();

  DateTime endMonth = DateTime.now();

  Map<DateTime, int> datasets = {};

  int totalFocusTime = 0;

  int totalTasks = 0;

  int completedTasks = 0;

  int incompleteTasks = 0;

  Map<DateTime, int> generateDataset(List<Task> tasks) {
    Map<DateTime, int> data = {};

    for (Task task in tasks) {
      // Lấy ngày từ startDate của task
      try {
        DateTime taskDate = DateTime(
            task.startDate!.year, task.startDate!.month, task.startDate!.day);
        // Nếu ngày đã có trong data, tăng giá trị
        if (data.containsKey(taskDate)) {
          data[taskDate] = data[taskDate]! + 1;
        } else {
          data[taskDate] = 1;
        }
      } catch (e) {
        continue;
      }
    }
    log(data.toString());
    return data;
  }

  @override
  Widget build(BuildContext context) {
    init();
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: heatMapMonth(context)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tháng ${month.month}/${month.year}',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                        onPressed: () {
                          showDatePicker(
                            context: context,
                            initialDate: month,
                            firstDate: DateTime(2023),
                            lastDate: DateTime(2050),
                            initialDatePickerMode: DatePickerMode.day,
                          ).then(
                            (value) {
                              if (value != null) {
                                context
                                    .read<StatisticsScreenViewModel>()
                                    .updateChartMonth(value, context);
                              }
                            },
                          );
                        },
                        icon: const Icon(Icons.calendar_month_outlined))
                  ],
                ),
                const SizedBox(height: 8),
                Text('Thời gian tập trung: $totalFocusTime'),
                const SizedBox(height: 8),
                Text('Tổng số công việc: $totalTasks'),
                const SizedBox(height: 8),
                Text('Đã hoàn thành: $completedTasks'),
                const SizedBox(height: 8),
                Text('Chưa hoàn thành: $incompleteTasks'),
                const SizedBox(height: 8),
              ],
            ),
          )
        ],
      ),
    );
  }

  void init() {
    // Xác định ngày bắt đầu và kết thúc của tháng
    startMonth = DateTime(month.year, month.month, 1);
    DateTime startOfNextMonth = (month.month < 12)
        ? DateTime(month.year, month.month + 1, 1)
        : DateTime(month.year + 1, 1, 1);
    endMonth = startOfNextMonth.subtract(const Duration(days: 1));

    _calculateStatistics();

    // Tạo datasets từ tasks
    datasets = generateDataset(tasks);
  }

  void _calculateStatistics() {
    try {
      // Tính tổng thời gian tập trung
      for (var i in tasks) {
        totalFocusTime += i.focusTime;
        if (i.isCompleted) {
          completedTasks++;
        } else {
          incompleteTasks++;
        }
      }
      // Tính tổng số công việc (giả sử `datasets` đã được tạo trước đó)
      totalTasks = tasks.length;
    } catch (e) {
      // Bắt lỗi và xử lý nếu có
      print('Lỗi khi tính toán: $e');
    }
  }

  HeatMap heatMapMonth(BuildContext context) {
    return HeatMap(
      startDate: startMonth,
      endDate: endMonth,
      datasets: datasets,
      colorMode: ColorMode.opacity,
      colorsets: const {
        1: Colors.green,
      },
      onClick: (value) {
        String strValue =
            "${datasets[value] ?? 0} công việc được thêm vào ngày ${value.day} tháng ${value.month}.";
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(strValue)));
      },
    );
  }
}
