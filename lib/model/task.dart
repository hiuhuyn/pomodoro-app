// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'package:pomodoro_focus/model/todo.dart';

enum RepeatType {
  none,
  daily,
  weekly,
  monthly,
}

// ignore: must_be_immutable
class Task extends Equatable {
  int? id;
  String? title;
  String? description;
  List<Todo> subTask = [];
  bool? isCompleted;

  // lặp lại
  RepeatType repeatType;
  List<int>?
      repeatDaysOfWeek; // Lưu trữ các ngày trong tuần cho lặp lại hàng tuần
  int? repeatDayOfMonth; // Lưu trữ 1 ngày trong tháng cho lặp lại hàng tháng
  // thời gian
  DateTime? startDate; // ngày bắt đầu
  DateTime? endDate; // ngày hết hạn

  int? focusTime; // Thời gian tập chung
  int? goalTime;
  Task({
    this.id,
    this.title,
    this.description,
    List<Todo>? subTask,
    this.isCompleted,
    this.repeatType = RepeatType.none,
    this.repeatDaysOfWeek,
    this.repeatDayOfMonth,
    this.startDate,
    this.endDate,
    this.focusTime,
    this.goalTime,
  }) {
    this.subTask = subTask ?? [];
    isCompleted ??= false;
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        subTask,
        isCompleted,
        repeatType,
        repeatDaysOfWeek,
        repeatDayOfMonth,
        startDate,
        endDate,
        focusTime,
        goalTime,
      ];

  Task copyWith({
    int? id,
    String? title,
    String? description,
    List<Todo>? subTask,
    bool? isCompleted,
    RepeatType? repeatType,
    List<int>? repeatDaysOfWeek,
    int? repeatDayOfMonth,
    DateTime? startDate,
    DateTime? endDate,
    int? focusTime,
    int? goalTime,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      subTask: subTask ?? this.subTask,
      isCompleted: isCompleted ?? this.isCompleted,
      repeatType: repeatType ?? this.repeatType,
      repeatDaysOfWeek: repeatDaysOfWeek ?? this.repeatDaysOfWeek,
      repeatDayOfMonth: repeatDayOfMonth ?? this.repeatDayOfMonth,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      focusTime: focusTime ?? this.focusTime,
      goalTime: goalTime ?? this.goalTime,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted == true ? 1 : 0,
      'repeatType': repeatType.name,
      'repeatDaysOfWeek': repeatDaysOfWeek,
      'repeatDayOfMonth': repeatDayOfMonth,
      'startDate': startDate?.millisecondsSinceEpoch,
      'endDate': endDate?.millisecondsSinceEpoch,
      'focusTime': focusTime,
      'goalTime': goalTime,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      subTask: map['subTask'],
      isCompleted: map['isCompleted'] == 1 ? true : false,
      repeatType: map['repeatType'] != null
          ? RepeatType.values.firstWhere(
              (element) => element.name == map['repeatType'],
            )
          : RepeatType.none,
      repeatDaysOfWeek: map['repeatDaysOfWeek'],
      repeatDayOfMonth: map['repeatDayOfMonth'],
      startDate: map['startDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['startDate'] as int)
          : null,
      endDate: map['endDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['endDate'] as int)
          : null,
      focusTime: map['focusTime'],
      goalTime: map['goalTime'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Task.fromJson(String source) =>
      Task.fromMap(json.decode(source) as Map<String, dynamic>);
}
