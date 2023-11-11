import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../backend/task_manager.dart';
import '../common_widgets/delete_confirmation.dart';
import '../common_widgets/add_or_edit_task.dart';

class TaskPage extends StatelessWidget {
  final Task task;
  const TaskPage({super.key, required this.task});

  Widget taskDetails() {
    final DateFormat formatter = DateFormat('yMMMEd');
    return Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: const EdgeInsets.only(top: 30, bottom: 50),
                  child: InputDecorator(
                      decoration: const InputDecoration(
                          labelText: "Title", border: OutlineInputBorder()),
                      child: Text(task.title,
                          softWrap: false,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis))),
              Padding(
                  padding: const EdgeInsets.only(bottom: 50),
                  child: InputDecorator(
                      decoration: const InputDecoration(
                          labelText: "Description",
                          border: OutlineInputBorder()),
                      child: Text(task.description,
                          softWrap: true,
                          maxLines: 15,
                          overflow: TextOverflow.ellipsis))),
              Padding(
                  padding: const EdgeInsets.only(bottom: 50),
                  child: InputDecorator(
                      decoration: const InputDecoration(
                          labelText: "Due Date", border: OutlineInputBorder()),
                      child: Text(formatter.format(task.dueDate),
                          softWrap: true))),
            ]));
  }

  Future<String?> editTaskDialog(
      BuildContext context, TaskManager taskManager) async {
    return showDialog<String>(
        context: context,
        builder: (BuildContext context) => StatefulBuilder(
            builder: (context, setState) => Dialog(
                child: AddOrEditTask(
                    taskManager: taskManager, task: task, addOrEdit: "Edit"))));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskManager>(
        builder: (_, taskManager, __) => Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                title: Text(task.title,
                    softWrap: false,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                actions: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.menu),
                    tooltip: "settings",
                    onPressed: () => Navigator.pushNamed(context, "/settings"),
                  )
                ],
              ),
              body: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topCenter,
                    child: taskDetails(),
                  ),
                  Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: FloatingActionButton(
                              heroTag:
                                  null, // https://stackoverflow.com/questions/50839282/how-to-add-multiple-floating-button-in-stack-widget-in-flutter
                              tooltip: "Delete Task",
                              onPressed: () => deleteConfirmationDialog(
                                          context, taskManager, task)
                                      .then((deleted) {
                                    if (deleted != null && deleted) {
                                      Navigator.of(context).pop();
                                    }
                                  }),
                              child: const Icon(Icons.delete)))),
                  Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: FloatingActionButton(
                              heroTag: null,
                              tooltip: "Edit Task",
                              onPressed: () =>
                                  editTaskDialog(context, taskManager),
                              child: const Icon(Icons.edit)))),
                ],
              ),
            ));
  }
}
