import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:pomodoro_focus/core/route/route_generate.dart';
import 'package:pomodoro_focus/views/screens/task_management/task_management_screen_viewmodel.dart';

import '../../core/unit.dart';
import '../../model/task.dart';

// ignore: must_be_immutable
class TaskItem extends StatefulWidget {
  TaskItem({super.key, required this.task, this.onTap});
  Task task;
  Function(Task task)? onTap;

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
      onTap: () {
        if (widget.onTap != null) widget.onTap!(widget.task);
      },
      child: Container(
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.all(8),
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
                  context
                      .read<TaskManagementScreenViewmodel>()
                      .saveTask(context, widget.task);
                });
              },
            ),
            if (widget.task.isCompleted == false)
              IconButton(
                onPressed: () {
                  RouteGenerate.navigatorPomofocus(context, task: widget.task);
                },
                icon: const Icon(Icons.play_circle_outline),
              ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.task.title ?? "none",
                    maxLines: 1,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                        ),
                  ),
                  if (widget.task.description != null)
                    Text(
                      widget.task.description.toString(),
                      maxLines: 1,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.normal,
                            overflow: TextOverflow.ellipsis,
                          ),
                    ),
                  Row(
                    children: [
                      if (widget.task.startDate != null &&
                          widget.task.endDate != null)
                        Text(formatTimeRange(
                            widget.task.startDate!, widget.task.endDate!)),
                      const Spacer(
                        flex: 1,
                      ),
                      if (widget.task.startDate != null &&
                          widget.task.endDate != null &&
                          widget.task.repeatType == RepeatType.none)
                        Text(formatTaskDate(
                            widget.task.startDate, widget.task.endDate)),
                      const Spacer(
                        flex: 3,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (widget.task.repeatType != RepeatType.none)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.repeat),
              ),
          ],
        ),
      ),
    );
  }
}
