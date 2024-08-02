import 'package:flutter/material.dart';

import '../../model/todo.dart';

enum ShowType { show, edit, create }

class TodoItem extends StatefulWidget {
  TodoItem._({required this.todo, this.onTap});
  Todo todo;
  ShowType showType = ShowType.show;
  Function(bool value)? onTap;
  factory TodoItem.showAndChangeComplate(
      {required Todo todo, Function(bool value)? onTap}) {
    return TodoItem._(
      todo: todo,
      onTap: onTap,
    );
  }
  @override
  State<TodoItem> createState() {
    if (showType == ShowType.show) {
      return _TodoItemStateShow();
    }
    return _TodoItemStateShow();
  }
}

class _TodoItemStateShow extends State<TodoItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.2),
              offset: const Offset(2, 2),
              blurRadius: 4,
            ),
          ]),
      child: Row(
        children: [
          Checkbox(
            value: widget.todo.completed,
            onChanged: (isChecked) {
              setState(() {
                widget.todo.completed = isChecked;
              });
              if (widget.onTap != null && isChecked != null) {
                widget.onTap!(isChecked);
              }
            },
          ),
          const SizedBox(width: 8),
          Text(widget.todo.title.toString()),
        ],
      ),
    );
  }
}
