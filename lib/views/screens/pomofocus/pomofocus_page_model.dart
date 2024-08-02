import 'dart:async';

import 'package:flutter/material.dart';

import '../../widgets/form_select_paramaters_timer.dart';

class PomofocusPageModel extends ChangeNotifier {
  int _maxSeconds = 60; // 60 seconds
  int _pomodoroTime = 25; // thời gian cho 1 phiên tập trung
  int _currentSeconds = 0; // giây hiện tại
  int _currentMinutes = 25; // phút hiện tại
  int _pomodoroNumber = 1; // số pomodoro
  int _currentPomodoroNumber = 1; // số pomodoro hiện tại
  int _shortBreakTime = 5; // thời gian nghỉ ngắn
  int _shortBreakLimit = 4; // số lần nghỉ ngắn trước khi nghỉ dài
  int _currentShortBreakTime = 5;
  int _longBreakTime = 15; // thời gian nghỉ dài
  int _totalTime = 0; // tổng thời gian

  Timer? _timer;
  bool _isTimerRunning = false;
  bool _isStopRunning = false;

  bool get isTimeRunning => _isTimerRunning;
  bool get isStopRunning => _isStopRunning;

  int get maxSeconds => _maxSeconds;
  int get pomodoroTime => _pomodoroTime;
  int get currentSeconds => _currentSeconds;
  int get currentMinutes => _currentMinutes;
  int get pomodoroNumber => _pomodoroNumber;
  int get currentPomodoroNumber => _currentPomodoroNumber;
  int get shortBreakTime => _shortBreakTime;
  int get shortBreakLimit => _shortBreakLimit;
  int get currentShortBreakTime => _currentShortBreakTime;
  int get longBreakTime => _longBreakTime;
  int get totalTime => _totalTime;

  PomofocusPageModel() {
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
    int? currentShortBreakTime,
    int? longBreakTime,
    int? totalTime,
  }) {
    _maxSeconds = maxSeconds ?? this.maxSeconds;
    _pomodoroTime = pomodoroTime ?? this.pomodoroTime;
    _currentSeconds = currentSeconds ?? this.currentSeconds;
    _currentMinutes = currentMinutes ?? this.pomodoroTime;
    _pomodoroNumber = pomodoroNumber ?? this.pomodoroNumber;
    _currentPomodoroNumber = currentPomodoroNumber ?? this.pomodoroNumber;
    _shortBreakTime = shortBreakTime ?? this.shortBreakTime;
    _shortBreakLimit = shortBreakLimit ?? this.shortBreakLimit;
    _currentShortBreakTime = currentShortBreakTime ?? this.shortBreakTime;
    _longBreakTime = longBreakTime ?? this.longBreakTime;
    _totalTime = totalTime ?? this.totalTime;
    notifyListeners();
  }

  startTimer({bool isResumed = false}) {
    _isTimerRunning = true;
    _isStopRunning = isResumed;
    if (!isResumed) {
      _currentMinutes = pomodoroTime - 1;
      _currentSeconds = maxSeconds;
    }
    notifyListeners();
    _timer = Timer.periodic(
      const Duration(milliseconds: 200),
      (timer) {
        if (currentSeconds == 0) {
          if (currentMinutes == 0) {
            stopTimer(reset: true);
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
      _currentMinutes = pomodoroTime;
      _currentSeconds = 0;
      _isStopRunning = false;
    }
    notifyListeners();
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
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }
}
