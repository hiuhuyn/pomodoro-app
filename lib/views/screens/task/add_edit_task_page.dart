import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      required this.descriptionController,
      required this.goalController});
  Task task;
  TextEditingController titleController;
  TextEditingController descriptionController;
  TextEditingController goalController;
  @override
  State<AddEditTaskPage> createState() => _AddEditTaskPageState();
}

class _AddEditTaskPageState extends State<AddEditTaskPage> {
  bool isClickInputDesc = false;
  bool isClickInputGoal = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Thông tin công việc",
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
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
                    ),
                    Container(
                      margin: const EdgeInsets.all(8),
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
                            isClickInputGoal = !isClickInputGoal;
                          });
                        },
                        leading: const Icon(Icons.golf_course_sharp),
                        title: Text(
                          "Mục tiêu ${formatMinutesToHHMM(widget.task.goalTime)}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: isClickInputGoal
                            ? TextFormField(
                                controller: widget.goalController,
                                maxLines: null,
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    try {
                                      widget.task.goalTime = int.parse(value);
                                    } catch (e) {
                                      widget.task.goalTime = 0;
                                    }
                                  });
                                },
                                maxLength: 5,
                                decoration: const InputDecoration(
                                  hintText:
                                      'Nhập thời gian mục tiêu của bạn...',
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
                    Container(
                      margin: const EdgeInsets.all(8),
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
                      margin: const EdgeInsets.all(8),
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
                        title: const Text("Mô tả"),
                        subtitle: isClickInputDesc
                            ? TextFormField(
                                controller: widget.descriptionController,
                                maxLines: null,
                                decoration: const InputDecoration(
                                  hintText: 'Nhập mô tả về công việc...',
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
            ),
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    margin: const EdgeInsets.all(10),
                    alignment: Alignment.center,
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
                    width: double.infinity,
                    child: Text(
                      "Hủy",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                ),
                Row(
                  children: [
                    if (widget.task.id != null)
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            context
                                .read<TaskManagementScreenViewmodel>()
                                .deleteTask(context, widget.task.id!);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            margin: const EdgeInsets.all(10),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.redAccent[100],
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
                            child: Text(
                              "Xóa",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          if (widget.titleController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                duration: Duration(seconds: 2),
                                content:
                                    Text("Vui lòng điền tên của công việc."),
                              ),
                            );
                            return;
                          }
                          widget.task.title = widget.titleController.text;
                          widget.task.description =
                              widget.descriptionController.text.isEmpty
                                  ? null
                                  : widget.descriptionController.text;
                          try {
                            widget.task.goalTime = int.parse(
                                widget.goalController.text.toString());
                          } catch (e) {
                            widget.task.goalTime = 0;
                          }

                          log(widget.task.toString());
                          context
                              .read<TaskManagementScreenViewmodel>()
                              .saveTask(context, widget.task);
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          margin: const EdgeInsets.all(10),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.blue,
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
                          child: Text(
                            "Lưu",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void showDateTimeDialog(BuildContext context) async {
    List<DateTime>? dateTimeList = await showOmniDateTimeRangePicker(
      context: context,
      startInitialDate: widget.task.startDate ?? DateTime.now(),
      startFirstDate: DateTime(1600).subtract(const Duration(days: 365)),
      startLastDate: DateTime.now().add(
        const Duration(days: 365 * 50),
      ),
      endInitialDate: widget.task.endDate ?? DateTime.now(),
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
