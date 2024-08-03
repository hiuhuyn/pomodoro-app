import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';

import '../../../model/task.dart';
import '../../../model/todo.dart';
import '../../../repositorys/repository_local.dart';
import '../../widgets/form_select_paramaters_timer.dart';

class PomofocusPageModel extends ChangeNotifier {
  TaskRepository taskRepository;

  int _maxSeconds = 60; // 60 seconds
  int _pomodoroTime = 25; // thời gian cho 1 phiên tập trung
  int _currentSeconds = 0; // giây hiện tại
  int _currentMinutes = 25; // phút hiện tại
  int _pomodoroNumber = 1; // số pomodoro
  int _currentPomodoroNumber = 0; // số pomodoro hiện tại
  int _shortBreakTime = 5; // thời gian nghỉ ngắn
  int _shortBreakLimit = 4; // số lần nghỉ ngắn trước khi nghỉ dài
  int _longBreakTime = 15; // thời gian nghỉ dài
  int _totalTime = 0; // tổng thời gian

  Timer? _timer;
  bool _isTimerRunning = false;
  bool _isStopRunning = false;

  bool _isBreak = false;

  bool get isTimeRunning => _isTimerRunning;
  bool get isStopRunning => _isStopRunning;
  bool get isBreak => _isBreak;

  int get maxSeconds => _maxSeconds;
  int get pomodoroTime => _pomodoroTime;
  int get currentSeconds => _currentSeconds;
  int get currentMinutes => _currentMinutes;
  int get pomodoroNumber => _pomodoroNumber;
  int get currentPomodoroNumber => _currentPomodoroNumber;
  int get breakTime {
    // xử lý thời gian nghỉ (ngắn hoặc dài)
    if (_currentPomodoroNumber % _shortBreakLimit == 0) {
      return _longBreakTime;
    }
    return _shortBreakTime;
  }

  int get shortBreakLimit => _shortBreakLimit;
  int get totalTime => _totalTime;
  Task? task;

  PomofocusPageModel(this.task, this.taskRepository) {
    _currentMinutes = pomodoroTime;
    _currentSeconds = 0;
  }

  void setAllAttributes({
    int? maxSeconds,
    int? pomodoroTime,
    int? currentSeconds,
    int? currentMinutes,
    int? pomodoroNumber,
    int? currentPomodoroNumber,
    int? shortBreakTime,
    int? shortBreakLimit,
    int? longBreakTime,
    int? totalTime,
  }) {
    _maxSeconds = maxSeconds ?? this.maxSeconds;
    _pomodoroTime = pomodoroTime ?? this.pomodoroTime;
    _currentSeconds = currentSeconds ?? this.currentSeconds;
    _currentMinutes = currentMinutes ?? this.pomodoroTime;
    _pomodoroNumber = pomodoroNumber ?? this.pomodoroNumber;
    _currentPomodoroNumber = currentPomodoroNumber ?? 0;
    _shortBreakTime = shortBreakTime ?? _shortBreakTime;
    _shortBreakLimit = shortBreakLimit ?? this.shortBreakLimit;
    _longBreakTime = longBreakTime ?? _longBreakTime;
    _totalTime = totalTime ?? this.totalTime;
    notifyListeners();
  }

  startTimer(BuildContext context, {bool isResumed = false}) {
    _isTimerRunning = true;
    _isStopRunning = isResumed;
    if (!isResumed) {
      if (_isBreak) {
        _currentMinutes = breakTime - 1;
      } else {
        _currentMinutes = pomodoroTime - 1;
      }
      _currentSeconds = maxSeconds;
    }
    notifyListeners();
    _timer = Timer.periodic(
      const Duration(milliseconds: 100),
      (timer) {
        if (currentSeconds == 0) {
          if (currentMinutes == 0) {
            if (!_isBreak) {
              _saveFocusTime(context);
              _currentPomodoroNumber++;
            }
            stopTimer(reset: true);
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text("Kết thúc phiên")));
          } else {
            _currentSeconds = maxSeconds;
            _currentMinutes--;
          }
        } else {
          _currentSeconds--;
        }
        notifyListeners();
      },
    );
  }

  stopTimer({bool reset = false}) {
    _timer?.cancel();
    _timer = null;
    _isTimerRunning = false;
    _isStopRunning = true;
    if (reset) {
      _currentSeconds = 0;
      _isStopRunning = false;
      _isBreak = !_isBreak;
      if (_isBreak) {
        _currentMinutes = breakTime;
      } else {
        _currentMinutes = pomodoroTime;
      }
    }
    notifyListeners();
  }

  Future endTimer(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Bạn có chắc muốn kết thúc đếm thời gian?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Hủy"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, "ok");
            },
            child: const Text("Đồng ý"),
          ),
        ],
      ),
    ).then(
      (value) {
        if (value == "ok") {
          if (!_isBreak) {
            _saveFocusTime(context);
            _currentPomodoroNumber++;
          }
          stopTimer(reset: true);
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Kết thúc phiên")));
        }
      },
    );
    notifyListeners();
  }

  Future _saveFocusTime(BuildContext context) async {
    if (task != null) {
      try {
        int focusTime = _pomodoroTime - currentMinutes;
        focusTime += task?.focusTime ?? 0;
        task?.focusTime = focusTime;
        await taskRepository.updateTask(task!);
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Lỗi lưu thời gian: $e")));
      }
    }
  }

  Future selectParametersTimer(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => FormSelectParamatersTimer(
        onSubmit: (pomodoroNumber, pomodoroTime, shortBreakTime,
            shortBreakLimit, longBreakTime, totalTime) {
          Navigator.pop(context, {
            'pomodoroNumber': pomodoroNumber,
            'pomodoroTime': pomodoroTime,
            'shortBreakTime': shortBreakTime,
            'shortBreakLimit': shortBreakLimit,
            'longBreakTime': longBreakTime,
            'totalTime': totalTime,
          });
        },
      ),
    ).then(
      (value) {
        if (value is Map<String, dynamic>) {
          setAllAttributes(
            pomodoroTime: value['pomodoroTime'],
            shortBreakTime: value['shortBreakTime'],
            shortBreakLimit: value['shortBreakLimit'],
            longBreakTime: value['longBreakTime'],
            totalTime: value['totalTime'],
            pomodoroNumber: value['pomodoroNumber'],
            currentSeconds: 0,
            currentPomodoroNumber: 0,
          );
        }
      },
    );
  }

  void pauseTimer() {
    _timer?.cancel();
    _timer = null;
    _isTimerRunning = false;
    notifyListeners();
  }

  void resumeTimer(BuildContext context) {
    startTimer(isResumed: true, context);
  }

  Future changeStausTodo(BuildContext context, Todo todo) async {
    if (task != null) {
      try {
        await taskRepository.updateTodo(todo);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Lỗi thay đổi trạng thái: $e")));
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }
}
