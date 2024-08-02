// ignore: must_be_immutable
import 'package:flutter/material.dart';

import '../../model/task.dart';
import 'task_item.dart';

// ignore: must_be_immutable
class ItemBuildListTask extends StatefulWidget {
  ItemBuildListTask({super.key, required this.title, required this.items});
  List<Task> items;
  String title;

  @override
  State<ItemBuildListTask> createState() => _ItemBuildListTaskState();
}

class _ItemBuildListTaskState extends State<ItemBuildListTask> {
  bool isShowList = true;
  double? height;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                widget.title,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              IconButton(
                icon: const Icon(Icons.arrow_drop_down_circle),
                onPressed: () {
                  setState(() {
                    isShowList = !isShowList;
                    height = isShowList ? 0 : null;
                  });
                },
              ),
            ],
          ),
          AnimatedContainer(
            duration: const Duration(
              seconds: 1,
            ),
            height: height,
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: widget.items.length,
              itemBuilder: (context, index) {
                return TaskItem(
                  task: widget.items[index],
                  onTap: () {
                    print("on tap");
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
