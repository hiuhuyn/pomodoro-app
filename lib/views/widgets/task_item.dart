import 'package:flutter/material.dart';
import 'package:pomodoro_focus/core/route/route_generate.dart';
import '../../core/unit.dart';
import '../../model/task.dart';

class TaskItem extends StatefulWidget {
  TaskItem({super.key, required this.task, this.onTap});
  Task task;
  Function()? onTap;

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                offset: const Offset(0, 1),
                blurRadius: 5.0,
              ),
            ],
          ),
          child: IgnorePointer(
            // ignoring: widget.task.isCompleted ?? false,
            ignoring: false,
            child: Row(
              children: [
                Checkbox(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  value: widget.task.isCompleted,
                  onChanged: (value) {
                    setState(() {
                      widget.task.isCompleted = value ?? false;
                    });
                  },
                ),
                if (widget.task.isCompleted == false)
                  IconButton(
                    onPressed: () {
                      RouteGenerate.navigatorPomofocus(context,
                          task: widget.task);
                    },
                    icon: const Icon(Icons.play_circle_outline),
                  ),
                Expanded(
                  child: GestureDetector(
                    onTap: widget.onTap,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.task.title ?? "none",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(formatTaskDate(
                            widget.task.startDate, widget.task.endDate)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
