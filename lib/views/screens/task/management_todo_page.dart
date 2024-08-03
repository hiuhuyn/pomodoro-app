import 'package:flutter/material.dart';
import 'package:pomodoro_focus/views/widgets/todo_item.dart';

import '../../../model/todo.dart';

// ignore: must_be_immutable
class ManagementTodoPage extends StatefulWidget {
  ManagementTodoPage({super.key, required this.values, this.idTask});
  List<Todo> values;
  int? idTask;
  @override
  State<ManagementTodoPage> createState() => _ManagementTodoPageState();
}

class _ManagementTodoPageState extends State<ManagementTodoPage> {
  final _titleTodoController = TextEditingController();
  Todo? todoSelect;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          const Text(
            "Danh sách nhiệm vụ",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          Expanded(
            flex: 20,
            child: ListView.builder(
              itemCount: widget.values.length,
              itemBuilder: (context, index) {
                return TodoItem.edit(
                  todo: widget.values[index],
                  onChangeStatus: (value) {
                    widget.values[index].completed = value;
                  },
                  onDelete: (value) {
                    setState(() {
                      widget.values.removeAt(index);
                      todoSelect = null;
                      _titleTodoController.clear();
                    });
                  },
                  onTap: (value) {
                    setState(() {
                      todoSelect = value;
                      _titleTodoController.text = value.title ?? "";
                    });
                  },
                );
              },
            ),
          ),
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 2,
                              spreadRadius: 1,
                            )
                          ]),
                      child: TextFormField(
                        controller: _titleTodoController,
                        maxLines: null,
                        decoration: const InputDecoration(
                          hintText: 'Nhập tên nhiệm vụ...',
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                          contentPadding: EdgeInsets.all(8),
                        ),
                      )),
                ),
                IconButton(
                    onPressed: () {
                      if (_titleTodoController.text.trim().isEmpty) {
                        return;
                      }
                      setState(() {
                        if (todoSelect != null) {
                          widget.values[widget.values.indexOf(todoSelect!)]
                            ..title = _titleTodoController.text
                            ..completed = false;
                          todoSelect = null;
                        } else {
                          widget.values.add(Todo(
                            idTask: widget.idTask,
                            title: _titleTodoController.text,
                            completed: false,
                          ));
                        }
                        _titleTodoController.clear();
                      });
                    },
                    icon: const Icon(Icons.check)),
              ],
            ),
          ),
          const Spacer(
            flex: 1,
          )
        ],
      ),
    );
  }
}
