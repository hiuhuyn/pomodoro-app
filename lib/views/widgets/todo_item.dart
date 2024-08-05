import 'package:flutter/material.dart';

import '../../model/todo.dart';

enum ShowType { show, edit }

// ignore: must_be_immutable
class TodoItem extends StatefulWidget {
  TodoItem._(
      {required this.todo,
      this.onChangeStatus,
      this.showType = ShowType.show,
      this.onTap,
      this.onDelete});
  Todo todo;
  ShowType showType;
  Function(bool value)? onChangeStatus;
  Function(Todo value)? onTap;
  Function(Todo value)? onDelete;

  factory TodoItem.showAndChangeComplate({
    required Todo todo,
    Function(bool value)? onChangeStatus,
    Function(Todo value)? onTap,
  }) {
    return TodoItem._(
      todo: todo,
      onChangeStatus: onChangeStatus,
      showType: ShowType.show,
      onTap: onTap,
    );
  }
  factory TodoItem.edit(
      {required Todo todo,
      Function(bool value)? onChangeStatus,
      Function(Todo value)? onTap,
      Function(Todo value)? onDelete}) {
    return TodoItem._(
      todo: todo,
      onChangeStatus: onChangeStatus,
      showType: ShowType.edit,
      onTap: onTap,
      onDelete: onDelete,
    );
  }

  @override
  // ignore: no_logic_in_create_state
  State<TodoItem> createState() {
    switch (showType) {
      case ShowType.edit:
        return _TodoItemStateEdit();
      default:
        return _TodoItemStateShow();
    }
  }
}

class _TodoItemStateShow extends State<TodoItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.onTap != null) {
          widget.onTap!(widget.todo);
        }
      },
      child: Container(
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
                if (widget.onChangeStatus != null && isChecked != null) {
                  widget.onChangeStatus!(isChecked);
                }
              },
            ),
            const SizedBox(width: 8),
            Text(widget.todo.title.toString()),
          ],
        ),
      ),
    );
  }
}

class _TodoItemStateEdit extends State<TodoItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.onTap != null) {
          widget.onTap!(widget.todo);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.all(8),
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
                if (widget.onChangeStatus != null && isChecked != null) {
                  widget.onChangeStatus!(isChecked);
                }
              },
            ),
            const SizedBox(width: 8),
            Text(widget.todo.title.toString()),
            const Spacer(),
            if (widget.onDelete != null)
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  widget.onDelete!(widget.todo);
                },
              )
          ],
        ),
      ),
    );
  }
}
