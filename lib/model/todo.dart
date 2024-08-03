// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class Todo extends Equatable {
  int? id;
  String? title;
  bool? completed;
  // ignore: non_constant_identifier_names
  int? idTask;
  Todo({
    this.id,
    this.title,
    this.completed,
    this.idTask,
  });

  @override
  List<Object?> get props => [id, title, completed, idTask];

  Todo copyWith({
    int? id,
    String? title,
    bool? completed,
    int? idTask,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      completed: completed ?? this.completed,
      idTask: idTask ?? this.idTask,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'completed': completed == true ? 1 : 0,
      'idTask': idTask,
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'],
      title: map['title'],
      completed: map['completed'] == 1 ? true : false,
      idTask: map['idTask'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Todo.fromJson(String source) =>
      Todo.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;
}
