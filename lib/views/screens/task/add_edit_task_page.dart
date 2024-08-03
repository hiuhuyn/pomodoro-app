import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:pomodoro_focus/views/screens/task_management/task_management_screen_viewmodel.dart';
import 'package:pomodoro_focus/views/widgets/dialog_set_repeat_task.dart';
import 'package:provider/provider.dart';

import '../../../core/unit.dart';
import '../../../model/task.dart';

// ignore: must_be_immutable
class AddEditTaskPage extends StatefulWidget {
  AddEditTaskPage(
      {super.key,
      required this.task,
      required this.titleController,
      required this.descriptionController});
  Task task;
  TextEditingController titleController;
  TextEditingController descriptionController;
  @override
  State<AddEditTaskPage> createState() => _AddEditTaskPageState();
}

class _AddEditTaskPageState extends State<AddEditTaskPage> {
  bool isClickInputDesc = false;

  @override
  void initState() {
    super.initState();

    log(widget.task.toJson());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 4,
                        color: Color(0x33000000),
                        offset: Offset(
                          2,
                          2,
                        ),
                        spreadRadius: 2,
                      )
                    ],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Tên công việc",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      TextFormField(
                        maxLines: null,
                        controller: widget.titleController,
                        decoration: const InputDecoration(
                          hintText: 'Nhập tên công việc...',
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                          contentPadding: EdgeInsets.all(8),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 18),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 4,
                    color: Color(0x33000000),
                    offset: Offset(
                      2,
                      2,
                    ),
                    spreadRadius: 2,
                  )
                ],
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(Icons.date_range),
                onTap: () {
                  showDateTimeDialog(context);
                },
                title: const Text("Đặt thời gian"),
                subtitle: (widget.task.startDate != null &&
                        widget.task.endDate != null)
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          widget.task.repeatType == RepeatType.none
                              ? Text(
                                  'Ngày: ${formatDateRange(widget.task.startDate!, widget.task.endDate!)}',
                                )
                              : const SizedBox(),
                          const SizedBox(width: 8),
                          Text(
                            'Thời gian: ${formatTimeRange(widget.task.startDate!, widget.task.endDate!)}',
                          ),
                        ],
                      )
                    : null,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 18),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 4,
                    color: Color(0x33000000),
                    offset: Offset(
                      2,
                      2,
                    ),
                    spreadRadius: 2,
                  )
                ],
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                onTap: () {
                  showDialogRepeatTask(context);
                },
                leading: const Icon(Icons.repeat),
                trailing: Switch(
                  value: widget.task.repeatType != RepeatType.none,
                  onChanged: (value) {
                    setState(() {
                      if (widget.task.repeatType == RepeatType.none) {
                        showDialogRepeatTask(context);
                      } else {
                        widget.task.repeatType = RepeatType.none;
                        widget.task.repeatDaysOfWeek = null;
                        widget.task.repeatDayOfMonth = null;
                      }
                    });
                  },
                ),
                title: const Text("Lặp lại công việc"),
                subtitle: widget.task.repeatType != RepeatType.none
                    ? Text(showTextRepeatTask().toString())
                    : null,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 18),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 4,
                    color: Color(0x33000000),
                    offset: Offset(
                      2,
                      2,
                    ),
                    spreadRadius: 2,
                  )
                ],
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                onTap: () {
                  setState(() {
                    isClickInputDesc = !isClickInputDesc;
                  });
                },
                leading: const Icon(Icons.note_outlined),
                title: const Text("Ghi chú"),
                subtitle: isClickInputDesc
                    ? TextFormField(
                        controller: widget.descriptionController,
                        maxLines: null,
                        decoration: const InputDecoration(
                          hintText: 'Nhập ghi chú về công việc...',
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                          contentPadding: EdgeInsets.all(8),
                        ),
                      )
                    : null,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(12),
        width: 450,
        child: ElevatedButton(
          onPressed: () {
            if (widget.titleController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  duration: Duration(seconds: 2),
                  content: Text("Vui lòng điền tên của công việc."),
                ),
              );
              return;
            }
            widget.task.title = widget.titleController.text;
            widget.task.description = widget.descriptionController.text.isEmpty
                ? null
                : widget.descriptionController.text;
            log(widget.task.toString());
            context
                .read<TaskManagementScreenViewmodel>()
                .saveTask(context, widget.task);
            Navigator.pop(context);
          },
          child: const Text("Lưu"),
        ),
      ),
    );
  }

  void showDateTimeDialog(BuildContext context) async {
    List<DateTime>? dateTimeList = await showOmniDateTimeRangePicker(
      context: context,
      startInitialDate: DateTime.now(),
      startFirstDate: DateTime(1600).subtract(const Duration(days: 365)),
      startLastDate: DateTime.now().add(
        const Duration(days: 365 * 50),
      ),
      endInitialDate: DateTime.now(),
      endFirstDate: DateTime(1600).subtract(const Duration(days: 3652)),
      endLastDate: DateTime.now().add(
        const Duration(days: 365 * 50),
      ),
      is24HourMode: false,
      isShowSeconds: false,
      minutesInterval: 1,
      secondsInterval: 1,
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      constraints: const BoxConstraints(
        maxWidth: 350,
        maxHeight: 650,
      ),
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1.drive(
            Tween(
              begin: 0,
              end: 1,
            ),
          ),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 200),
      barrierDismissible: true,
    );
    if (!context.mounted) return;

    if (dateTimeList != null && dateTimeList.length == 2) {
      DateTime startDate = dateTimeList[0];
      DateTime endDate = dateTimeList[1];

      if (endDate.isBefore(startDate) || endDate.isAtSameMomentAs(startDate)) {
        // Hiển thị thông báo lỗi hoặc yêu cầu người dùng chọn lại
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Lỗi'),
              content: const Text(
                  'Thời gian kết thúc phải lớn hơn thời gian bắt đầu.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    // Gọi lại hàm để chọn lại
                    showDateTimeDialog(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        // Xử lý logic khi thời gian hợp lệ
        setState(() {
          widget.task.startDate = startDate;
          widget.task.endDate = endDate;
        });
      }
    }
  }

  Future showDialogRepeatTask(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => DialogSetRepeatTask(
        task: widget.task,
        onSave: (daysOfWeek, dayOfMonth, daily) {
          setState(() {
            if (daily == true) {
              widget.task.repeatType = RepeatType.daily;
              widget.task.repeatDayOfMonth = null;
              widget.task.repeatDaysOfWeek = null;
            } else if (daysOfWeek != null &&
                !daysOfWeek.every((day) => day == 0)) {
              widget.task.repeatType = RepeatType.weekly;
              widget.task.repeatDayOfMonth = null;
              widget.task.repeatDaysOfWeek = daysOfWeek;
            } else if (dayOfMonth != null) {
              widget.task.repeatType = RepeatType.monthly;
              widget.task.repeatDayOfMonth = dayOfMonth;
              widget.task.repeatDaysOfWeek = null;
            } else {
              widget.task.repeatType = RepeatType.none;
              widget.task.repeatDayOfMonth = null;
              widget.task.repeatDaysOfWeek = null;
            }
          });
        },
      ),
    );
  }

  String? showTextRepeatTask() {
    switch (widget.task.repeatType) {
      case RepeatType.daily:
        return 'Hằng ngày';
      case RepeatType.weekly:
        if (widget.task.repeatDaysOfWeek == null) {
          return null;
        }
        if (widget.task.repeatDaysOfWeek!.every((day) => day == 0)) {
          return null;
        }
        log(widget.task.repeatDaysOfWeek.toString());
        final repeatDaysOfWeek = widget.task.repeatDaysOfWeek;
        List<String> repeat = [];
        for (int i = 0; i < repeatDaysOfWeek!.length; i++) {
          if (repeatDaysOfWeek[i] == 1) {
            if (i < 6) {
              repeat.add('T${i + 2}');
            } else {
              repeat.add('CN');
            }
          }
        }
        return 'Hằng tuần vào các ngày: ${repeat.join(', ')}';
      case RepeatType.monthly:
        if (widget.task.repeatDayOfMonth == null) {
          return null;
        }
        return 'Hằng tháng vào ngày: ${widget.task.repeatDayOfMonth}';
      default:
        return null;
    }
  }
}
