import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../backend/task_manager.dart';
import 'task_page.dart';
import '../common_widgets/delete_confirmation.dart';
import '../common_widgets/add_or_edit_task.dart';

class HomePage extends StatelessWidget {
  final double taskTileHeight = 70.0;
  final double deleteButtonWidth = 50.0;
  final double taskDividerMargin = 20.0;

  const HomePage({super.key});

  Widget taskList(BuildContext context, TaskManager taskManager) {
    if (taskManager.tasks.isEmpty) {
      return Align(
          alignment: Alignment.topCenter,
          child: Text(taskManager.readTasksMessage,
              style: const TextStyle(height: 3.0, fontSize: 14.0)));
    }
    return ListView.builder(
        itemCount: taskManager.tasks.length,
        itemBuilder: (context, index) {
          return Column(children: <Widget>[
            taskTile(context, taskManager, index),
            Divider(
                height: 1.0,
                indent: taskDividerMargin,
                endIndent: taskDividerMargin)
          ]);
        });
  }

  Widget taskTile(BuildContext context, TaskManager taskManager, int index) {
    Task task = taskManager.tasks.elementAt(index);
    final DateFormat formatter = DateFormat('MMMEd');
    return SizedBox(
        height: taskTileHeight,
        child: Row(children: [
          // Row used to vertically center delete button
          Expanded(
              child: ListTile(
                  title: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 100),
                      child: Text(task.title,
                          maxLines: 1, overflow: TextOverflow.ellipsis)),
                  subtitle: Text(task.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12.0)),
                  trailing: Text(
                    "due ${formatter.format(task.dueDate)}",
                    style: const TextStyle(fontSize: 12.0),
                  ),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TaskPage(task: task))))),
          SizedBox(
              width: deleteButtonWidth,
              child: IconButton(
                  onPressed: () async {
                    await deleteConfirmationDialog(context, taskManager, task);
                  },
                  icon: const Icon(Icons.delete)))
        ]));
  }

  Future<void> addTaskDialog(
      BuildContext context, TaskManager taskManager) async {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) => StatefulBuilder(
            builder: (context, setState) => Dialog(
                child: AddOrEditTask(
                    taskManager: taskManager,
                    task: Task("", "", DateTime.now()),
                    addOrEdit: "Add"))));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskManager>(
        builder: (_, taskManager, __) => Scaffold(
              appBar: AppBar(
                title: const Text("To Do"),
                actions: <Widget>[
                  IconButton(
                      icon: const Icon(Icons.menu),
                      tooltip: "Settings",
                      onPressed: () {
                        Navigator.pushNamed(context, "/settings");
                      })
                ],
              ),
              body: taskList(context, taskManager),
              floatingActionButton: FloatingActionButton(
                tooltip: "Add Task",
                onPressed: () => addTaskDialog(context, taskManager),
                child: const Icon(Icons.add),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.endFloat,
            ));
  }
}
