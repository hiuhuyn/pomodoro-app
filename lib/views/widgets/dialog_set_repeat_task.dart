import 'dart:developer';

import 'package:flutter/material.dart';

import '../../model/task.dart';

// ignore: must_be_immutable
class DialogSetRepeatTask extends StatefulWidget {
  DialogSetRepeatTask({super.key, required this.task, required this.onSave});
  Task task;
  Function(List<int>? daysOfWeek, int? dayOfMonth, bool? daily) onSave;
  @override
  State<DialogSetRepeatTask> createState() => _DialogSetRepeatTaskState();
}

class _DialogSetRepeatTaskState extends State<DialogSetRepeatTask> {
  List<int>? daysOfWeek;
  int? dayOfMonth;
  bool? daily;
  RepeatType repeatType = RepeatType.daily;
  @override
  void initState() {
    super.initState();
    if (widget.task.repeatType != RepeatType.none) {
      repeatType = widget.task.repeatType;
      daysOfWeek = widget.task.repeatDaysOfWeek != null
          ? List.from(widget.task.repeatDaysOfWeek!)
          : null;
      dayOfMonth = widget.task.repeatDayOfMonth;
      log(daysOfWeek.toString());
    } else {
      repeatType = RepeatType.daily;
      daily = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: const Text("Đặt làm công việc lặp lại"),
      content: Column(
        children: [
          Container(
            height: 60,
            width: 400,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      repeatType = RepeatType.daily;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: repeatType == RepeatType.daily
                          ? Colors.blue
                          : Colors.blue[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "Hằng ngày",
                      style: TextStyle(
                        color: repeatType == RepeatType.daily
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      repeatType = RepeatType.weekly;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: repeatType == RepeatType.weekly
                          ? Colors.blue
                          : Colors.blue[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "Hằng tuần",
                      style: TextStyle(
                        color: repeatType == RepeatType.weekly
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      repeatType = RepeatType.monthly;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: repeatType == RepeatType.monthly
                          ? Colors.blue
                          : Colors.blue[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "Hằng tháng",
                      style: TextStyle(
                        color: repeatType == RepeatType.monthly
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          buildContent(),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Hủy"),
        ),
        ElevatedButton(
          onPressed: () {
            switch (repeatType) {
              case RepeatType.daily:
                daysOfWeek = null;
                dayOfMonth = null;
                daily = true;
                break;
              case RepeatType.weekly:
                dayOfMonth = null;
                daily = false;
                if (daysOfWeek != null) {
                  if (daysOfWeek!.every((day) => day == 0)) {
                    daysOfWeek = null;
                  }
                }
                break;
              case RepeatType.monthly:
                daysOfWeek = null;
                daily = null;
                break;
              case RepeatType.none:
                daysOfWeek = null;
                daily = null;
                dayOfMonth = null;
                break;
            }
            widget.onSave(
              daysOfWeek,
              dayOfMonth,
              daily,
            );
            Navigator.pop(context, true);
          },
          child: const Text("Lưu"),
        ),
      ],
    );
  }

  Widget buildContent() {
    switch (repeatType) {
      case RepeatType.daily:
        return buildDailyContent();
      case RepeatType.weekly:
        return buildWeeklyContent();
      case RepeatType.monthly:
        return buildMonthlyContent();
      default:
        return Container();
    }
  }

  Widget buildDailyContent() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: const Text("Daily"),
    );
  }

  Widget buildWeeklyContent() {
    daysOfWeek ??= [0, 0, 0, 0, 0, 0, 0];
    return Container(
      width: 400,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(8),
      child: ListView.builder(
        itemCount: daysOfWeek?.length,
        itemBuilder: (context, index) {
          String showStr = "T ${index + 2}";
          if (index == 6) {
            showStr = "CN";
          }
          return InkWell(
            onTap: () {
              setState(() {
                daysOfWeek![index] = daysOfWeek![index] == 1 ? 0 : 1;
              });
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: daysOfWeek![index] == 1 ? Colors.blue : Colors.grey[200],
                borderRadius: BorderRadius.circular(25.0),
                border: Border.all(
                  color: daysOfWeek![index] == 1 ? Colors.blue : Colors.grey,
                ),
              ),
              child: Text(showStr),
            ),
          );
        },
        scrollDirection: Axis.horizontal,
      ),
    );
  }

  Widget buildMonthlyContent() {
    dayOfMonth ??= 1;
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title: const Text("Ngày trong tháng"),
        subtitle: Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: List.generate(31, (index) {
            final number = index + 1;
            final isSelected = number == dayOfMonth;

            return GestureDetector(
              onTap: () {
                setState(() {
                  dayOfMonth = number;
                });
              },
              child: Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue : Colors.grey[200],
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                    color: isSelected ? Colors.blue : Colors.grey,
                    width: 2.0,
                  ),
                ),
                child: Text(
                  number.toString(),
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
