import 'package:flutter/material.dart';
import '../../backend/task_manager.dart';

Future<bool?> deleteConfirmationDialog(
    BuildContext context, TaskManager taskManager, Task task) async {
  return await showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
            title: const Text("Delete Task?"),
            content: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 100),
                child: Text(task.title, overflow: TextOverflow.ellipsis)),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text("No"),
              ),
              TextButton(
                onPressed: () {
                  taskManager.deleteTask(task);
                  Navigator.of(context).pop(true);
                },
                child: const Text("Yes"),
              ),
            ],
          ));
}
