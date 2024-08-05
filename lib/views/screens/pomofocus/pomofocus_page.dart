import 'package:flutter/material.dart';
import 'package:pomodoro_focus/views/screens/pomofocus/pomofocus_page_model.dart';
import 'package:pomodoro_focus/views/screens/task_management/task_management_screen_viewmodel.dart';
import 'package:pomodoro_focus/views/widgets/todo_item.dart';
import 'package:provider/provider.dart';

import '../../../model/task.dart';

// ignore: must_be_immutable
class PomofocusScreen extends StatefulWidget {
  PomofocusScreen({super.key, this.task});
  Task? task;

  @override
  State<PomofocusScreen> createState() => _PomofocusScreenState();
}

class _PomofocusScreenState extends State<PomofocusScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.task != null && widget.task!.id != null) {
      context
          .read<TaskManagementScreenViewmodel>()
          .findTodosByTask(context, widget.task!.id!)
          .then(
        (value) {
          setState(() {
            widget.task!.subTask = value;
          });
        },
      );
    }

    Future.delayed(const Duration(milliseconds: 100)).then(
      (value) {
        context.read<PomofocusPageModel>().selectParametersTimer(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFFE29F),
              Color(0xFFffa99f),
              Color(0xFFff719a),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Consumer<PomofocusPageModel>(
              builder: (context, model, child) {
                return AppBar(
                  backgroundColor: Colors.transparent,
                  leading: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      )),
                  elevation: 0,
                  centerTitle: false,
                  title: Text(
                    'Số Pomodoro: ${model.currentPomodoroNumber}/${model.pomodoroNumber}',
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                );
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    buildTimer(),
                    const SizedBox(
                      height: 10,
                    ),
                    buildBreakCount(),
                    buildButton(),
                    buildTodos(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget buildButton() {
    return Consumer<PomofocusPageModel>(
      builder: (context, model, child) {
        if (model.isTimeRunning) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buttonWidget(
                title: "Tạm dừng",
                icon: Icons.stop_circle_rounded,
                onPressed: () {
                  model.pauseTimer();
                },
              ),
              const SizedBox(width: 10),
              buttonWidget(
                title: "Kết thúc",
                icon: Icons.skip_next_rounded,
                onPressed: () {
                  model.endTimer(context);
                },
              ),
            ],
          );
        } else if (model.isStopRunning) {
          return buttonWidget(
            title: "Tiếp tục",
            icon: Icons.play_arrow_rounded,
            onPressed: () {
              model.resumeTimer(context);
            },
          );
        } else {
          return buttonWidget(
            title: "Bắt đầu",
            icon: Icons.play_arrow_rounded,
            onPressed: () {
              model.startTimer(context);
            },
          );
        }
      },
    );
  }

  Widget buildBreakCount() {
    return Consumer<PomofocusPageModel>(
      builder: (context, model, child) {
        var wPomodoro = <Widget>[];
        for (int i = 0; i < model.shortBreakLimit; i++) {
          if (i <=
              ((model.currentPomodoroNumber % model.shortBreakLimit + 1) - 1)) {
            wPomodoro.add(
              const Icon(
                Icons.check_circle,
                color: Colors.red,
                size: 20,
              ),
            );
          } else {
            wPomodoro.add(
              const Icon(
                Icons.check_circle_outline,
                color: Color.fromARGB(255, 255, 185, 185),
                size: 20,
              ),
            );
          }
        }
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: wPomodoro,
          ),
        );
      },
    );
  }

  Widget buildTimer() {
    return Consumer<PomofocusPageModel>(
      builder: (context, model, child) {
        return SizedBox(
          width: 320,
          height: 320,
          child: Stack(
            alignment: Alignment.center,
            fit: StackFit.expand,
            children: [
              CircularProgressIndicator(
                value: model.isBreak
                    ? model.currentMinutes / model.breakTime
                    : model.currentMinutes / model.pomodoroTime,
                backgroundColor: const Color.fromARGB(255, 100, 255, 149),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: CircularProgressIndicator(
                  value: model.currentSeconds / model.maxSeconds,
                  backgroundColor: const Color(0xfff9f047),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 10,
                ),
              ),
              Center(
                child: Text(
                  '${model.currentMinutes.toString().padLeft(2, '0')}:${model.currentSeconds.toString().padLeft(2, '0')}',
                  style: const TextStyle(
                    fontSize: 70,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget buttonWidget(
      {required String title, IconData? icon, required Function() onPressed}) {
    return ElevatedButton.icon(
      style: ButtonStyle(
        backgroundColor:
            WidgetStateProperty.all<Color>(Colors.white), // Màu nền
        foregroundColor:
            WidgetStateProperty.all<Color>(Colors.white), // Màu chữ
        padding: WidgetStateProperty.all<EdgeInsets>(
            const EdgeInsets.symmetric(horizontal: 30, vertical: 15)), // Đệm
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0), // Bo góc
            side: const BorderSide(color: Colors.white), // Đường viền
          ),
        ),
      ),
      onPressed: onPressed,
      icon: icon != null
          ? Icon(
              icon,
              color: Colors.red,
            )
          : null,
      label: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  Widget buildTodos() {
    return Visibility(
      visible: widget.task != null && widget.task!.subTask.isNotEmpty,
      child: ListView.builder(
        padding: const EdgeInsets.all(8),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: widget.task!.subTask.length,
        itemBuilder: (context, index) {
          return TodoItem.showAndChangeComplate(
            todo: widget.task!.subTask[index],
            onChangeStatus: (value) {
              widget.task!.subTask[index].completed = value;
              context
                  .read<PomofocusPageModel>()
                  .changeStatusTodo(context, widget.task!.subTask[index]);
            },
          );
        },
      ),
    );
  }
}
