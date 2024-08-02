
import 'package:flutter/material.dart';
import 'package:pomodoro_focus/model/todo.dart';
import 'package:pomodoro_focus/views/screens/pomofocus/pomofocus_page_model.dart';
import 'package:pomodoro_focus/views/widgets/todo_item.dart';
import 'package:provider/provider.dart';

class PomofocusScreen extends StatefulWidget {
  const PomofocusScreen({super.key});

  @override
  State<PomofocusScreen> createState() => _PomofocusScreenState();
}

class _PomofocusScreenState extends State<PomofocusScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PomofocusPageModel(),
      child: Scaffold(
        body: Container(
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
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Consumer<PomofocusPageModel>(
                  builder: (context, pomofocusModel, child) {
                    return AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      title: Text(
                        'Số Pomodoro: ${pomofocusModel.currentPomodoroNumber}/${pomofocusModel.pomodoroNumber}',
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      actions: [
                        IconButton(
                          onPressed: () {
                            context
                                .read<PomofocusPageModel>()
                                .selectParametersTimer(context);
                          },
                          icon: const Icon(Icons.settings),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 10),
                buildBreakCount(),
                buildTimer(),
                const SizedBox(
                  height: 50,
                ),
                buildButton(),
                buildTodos(),
              ],
            ),
          ),
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
      builder: (context, pomofocusModel, child) {
        if (pomofocusModel.isTimeRunning) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buttonWidget(
                title: "Tạm dừng",
                icon: Icons.stop_circle_rounded,
                onPressed: () {
                  pomofocusModel.stopTimer();
                },
              ),
              const SizedBox(width: 10),
              buttonWidget(
                title: "Kết thúc",
                icon: Icons.skip_next_rounded,
                onPressed: () {
                  pomofocusModel.stopTimer(reset: true);
                },
              ),
            ],
          );
        } else if (pomofocusModel.isStopRunning) {
          return buttonWidget(
            title: "Tiếp tục",
            icon: Icons.play_arrow_rounded,
            onPressed: () {
              pomofocusModel.startTimer(isResumed: true);
            },
          );
        } else {
          return buttonWidget(
            title: "Bắt đầu",
            icon: Icons.play_arrow_rounded,
            onPressed: () {
              pomofocusModel.startTimer();
            },
          );
        }
      },
    );
  }

  Widget buildBreakCount() {
    return Consumer<PomofocusPageModel>(
      builder: (context, pomofocusModel, child) {
        var wPomodoro = <Widget>[];

        for (int i = 1; i <= pomofocusModel.shortBreakLimit; i++) {
          if (i <= pomofocusModel.currentShortBreakTime) {
            wPomodoro.add(
              const Icon(
                Icons.check_circle,
                color: Colors.red,
                size: 45,
              ),
            );
          } else {
            wPomodoro.add(
              const Icon(
                Icons.check_circle_outline,
                color: Color.fromARGB(255, 255, 185, 185),
                size: 45,
              ),
            );
          }
        }
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: wPomodoro,
          ),
        );
      },
    );
  }

  Widget buildTimer() {
    return Consumer<PomofocusPageModel>(
      builder: (context, pomofocusModel, child) {
        return SizedBox(
          width: 320,
          height: 320,
          child: Stack(
            alignment: Alignment.center,
            fit: StackFit.expand,
            children: [
              CircularProgressIndicator(
                value:
                    pomofocusModel.currentMinutes / pomofocusModel.pomodoroTime,
                backgroundColor: const Color.fromARGB(255, 100, 255, 149),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: CircularProgressIndicator(
                  value:
                      pomofocusModel.currentSeconds / pomofocusModel.maxSeconds,
                  backgroundColor: const Color(0xfff9f047),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 10,
                ),
              ),
              Center(
                child: Text(
                  '${pomofocusModel.currentMinutes.toString().padLeft(2, '0')}:${pomofocusModel.currentSeconds.toString().padLeft(2, '0')}',
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
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            return TodoItem.showAndChangeComplate(
              todo: Todo(
                title: "Todos $index",
                completed: false,
              ),
            );
          },
        ),
      ),
    );
  }
}
