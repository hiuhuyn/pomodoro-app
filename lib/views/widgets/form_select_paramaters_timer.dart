import 'package:flutter/material.dart';

import '../../core/unit.dart';

class FormSelectParamatersTimer extends StatefulWidget {
  FormSelectParamatersTimer(
      {super.key,
      required this.onSubmit,
      this.pomodoroTime = 25,
      this.longBreakTime = 15,
      this.pomodoroNumber = 1,
      this.shortBreakLimit = 4,
      this.shortBreakTime = 5});
  Function(int pomorodoNumber, int pomodoroTimer, int shortBreakTime,
      int shortBreakLimit, int longBreakTime, int totalTime) onSubmit;
  int pomodoroNumber = 1;
  int pomodoroTime = 25;
  int shortBreakTime = 5;
  int shortBreakLimit = 4;
  int longBreakTime = 15;

  @override
  State<FormSelectParamatersTimer> createState() =>
      _FormSelectParamatersTimerState();
}

class _FormSelectParamatersTimerState extends State<FormSelectParamatersTimer> {
  int pomorodoNumber = 1;
  int pomodoroTimer = 25;
  int shortBreakTime = 5;
  int shortBreakLimit = 4;
  int longBreakTime = 15;
  @override
  void initState() {
    super.initState();
    pomodoroTimer = widget.pomodoroTime;
    shortBreakTime = widget.shortBreakTime;
    shortBreakLimit = widget.shortBreakLimit;
    longBreakTime = widget.longBreakTime;
    pomorodoNumber = widget.pomodoroNumber;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Tùy chỉnh thông số cho đồng hồ Pomodoro"),
      content: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: const Text("Thời gian cho 1 Pomodoro"),
              subtitle: DropdownButton(
                underline: const SizedBox(),
                value: pomodoroTimer,
                isExpanded: true,
                items: const [
                  DropdownMenuItem(value: 1, child: Text("1 phút")),
                  DropdownMenuItem(value: 2, child: Text("2 phút")),
                  DropdownMenuItem(value: 5, child: Text("5 phút")),
                  DropdownMenuItem(value: 10, child: Text("10 phút")),
                  DropdownMenuItem(value: 15, child: Text("15 phút")),
                  DropdownMenuItem(value: 25, child: Text("25 phút")),
                  DropdownMenuItem(value: 30, child: Text("30 phút")),
                  DropdownMenuItem(value: 45, child: Text("45 phút")),
                  DropdownMenuItem(value: 60, child: Text("60 phút")),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      pomodoroTimer = value;
                    });
                  }
                },
              ),
            ),
            ListTile(
              title: Text(
                  "Số Pomodoro ($pomodoroTimer x $pomorodoNumber = ${pomodoroTimer * pomorodoNumber} phút)"),
              subtitle: Slider(
                label: "$pomorodoNumber",
                value: pomorodoNumber.toDouble(),
                max: 100,
                min: 1,
                divisions: 100,
                onChanged: (value) {
                  setState(() {
                    pomorodoNumber = value.toInt();
                  });
                },
              ),
            ),
            ListTile(
              title: const Text("Thời gian nghỉ ngắn"),
              subtitle: DropdownButton(
                underline: const SizedBox(),
                value: shortBreakTime,
                isExpanded: true,
                items: const [
                  DropdownMenuItem(value: 1, child: Text("1 phút")),
                  DropdownMenuItem(value: 2, child: Text("2 phút")),
                  DropdownMenuItem(value: 5, child: Text("5 phút")),
                  DropdownMenuItem(value: 10, child: Text("10 phút")),
                  DropdownMenuItem(value: 15, child: Text("15 phút")),
                  DropdownMenuItem(value: 25, child: Text("25 phút")),
                  DropdownMenuItem(value: 30, child: Text("30 phút")),
                  DropdownMenuItem(value: 45, child: Text("45 phút")),
                  DropdownMenuItem(value: 60, child: Text("60 phút")),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      shortBreakTime = value;
                    });
                  }
                },
              ),
            ),
            ListTile(
              title: const Text("Thời gian nghỉ dài"),
              subtitle: DropdownButton(
                underline: const SizedBox(),
                value: longBreakTime,
                isExpanded: true,
                items: const [
                  DropdownMenuItem(value: 1, child: Text("1 phút")),
                  DropdownMenuItem(value: 2, child: Text("2 phút")),
                  DropdownMenuItem(value: 5, child: Text("5 phút")),
                  DropdownMenuItem(value: 10, child: Text("10 phút")),
                  DropdownMenuItem(value: 15, child: Text("15 phút")),
                  DropdownMenuItem(value: 25, child: Text("25 phút")),
                  DropdownMenuItem(value: 30, child: Text("30 phút")),
                  DropdownMenuItem(value: 45, child: Text("45 phút")),
                  DropdownMenuItem(value: 60, child: Text("60 phút")),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      longBreakTime = value;
                    });
                  }
                },
              ),
            ),
            ListTile(
              title: const Text("Số lần nghỉ ngắn trước khi đến nghỉ dài"),
              subtitle: DropdownButton(
                underline: const SizedBox(),
                value: shortBreakLimit,
                isExpanded: true,
                items: const [
                  DropdownMenuItem(value: 1, child: Text("1 lần")),
                  DropdownMenuItem(value: 2, child: Text("2 lần")),
                  DropdownMenuItem(value: 3, child: Text("3 lần")),
                  DropdownMenuItem(value: 4, child: Text("4 lần")),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      shortBreakLimit = value;
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        Text("Tổng thời gian: ${formatMinutesToHHMM(calculateTotalTime())}"),
        ElevatedButton(
            onPressed: () {
              widget.onSubmit(
                pomorodoNumber,
                pomodoroTimer,
                shortBreakTime,
                shortBreakLimit,
                longBreakTime,
                calculateTotalTime(),
              );
            },
            child: const Text("Lưu"))
      ],
    );
  }

  int calculateTotalTime() {
    int totalWorkTime = pomodoroTimer * pomorodoNumber;
    int totalShortBreaks = pomorodoNumber - 1;
    int totalShortBreakTime = shortBreakTime * totalShortBreaks;
    int totalLongBreaks = totalShortBreaks ~/ shortBreakLimit;
    int totalLongBreakTime = longBreakTime * totalLongBreaks;
    int remainingShortBreaks = totalShortBreaks % shortBreakLimit;
    int remainingShortBreakTime = shortBreakTime * remainingShortBreaks;

    int totalTime = totalWorkTime +
        totalShortBreakTime +
        totalLongBreakTime +
        remainingShortBreakTime;

    return totalTime;
  }
}
