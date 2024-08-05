import 'package:flutter/material.dart';
import 'package:pomodoro_focus/views/screens/statistics/statistics_screen_viewmodel.dart';
import 'package:provider/provider.dart';

import '../../../../core/unit.dart';

class DayStatisticsWidget extends StatefulWidget {
  DayStatisticsWidget({
    super.key,
    required this.totalCompletedTasks,
    required this.totalFocusTime,
    required this.totalUncompletedTasks,
    required this.date,
  });
  int totalCompletedTasks;
  int totalUncompletedTasks;
  int totalFocusTime;
  DateTime date;

  @override
  State<DayStatisticsWidget> createState() => _DayStatisticsWidgetState();
}

class _DayStatisticsWidgetState extends State<DayStatisticsWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    bool isToday = widget.date.year == now.year &&
        widget.date.month == now.month &&
        widget.date.day == now.day;
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                isToday
                    ? "Hôm nay"
                    : "Ngày ${formatDate(widget.date, isYear: true)}",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const Spacer(),
              if (isToday) Text(formatDate(widget.date, isYear: true)),
              IconButton(
                onPressed: () {
                  showDatePicker(
                    context: context,
                    initialDate: widget.date,
                    firstDate: DateTime(2023),
                    lastDate: DateTime(2050),
                    initialDatePickerMode: DatePickerMode.day,
                  ).then(
                    (value) {
                      if (value != null) {
                        context
                            .read<StatisticsScreenViewModel>()
                            .updateChartToday(context, value);
                      }
                    },
                  );
                },
                icon: const Icon(Icons.calendar_month_outlined),
              ),
            ],
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
                        widget.totalCompletedTasks.toString(),
                        style:
                            Theme.of(context).textTheme.headlineLarge?.copyWith(
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
                        widget.totalUncompletedTasks.toString(),
                        style:
                            Theme.of(context).textTheme.headlineLarge?.copyWith(
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
          Text('Tập trung: ${widget.totalFocusTime} phút'),
        ],
      ),
    );
  }
}
