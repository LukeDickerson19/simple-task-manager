import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../backend/task_manager.dart';

class AddOrEditTask extends StatefulWidget {
  final TaskManager taskManager;
  final Task task;
  final String addOrEdit;
  const AddOrEditTask(
      {super.key,
      required this.taskManager,
      required this.task,
      required this.addOrEdit});

  @override
  State<AddOrEditTask> createState() => _AddOrEditTaskState();
}

class _AddOrEditTaskState extends State<AddOrEditTask> {
  late TextEditingController titleController, descriptionController;
  late DateTime selectedDueDate;

  @override
  void initState() {
    titleController = TextEditingController(text: widget.task.title);
    descriptionController =
        TextEditingController(text: widget.task.description);
    selectedDueDate = widget.task.dueDate;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
  }

  Widget titleInput() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: TextField(
          autocorrect: false,
          controller: titleController,
          maxLength: 100,
          decoration: const InputDecoration(
              border: OutlineInputBorder(borderSide: BorderSide()),
              labelText: "Title",
              floatingLabelBehavior: FloatingLabelBehavior.always),
        ));
  }

  Widget descriptionInput() {
    return Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: TextField(
          autocorrect: false,
          controller: descriptionController,
          maxLength: 1000,
          maxLines: null,
          decoration: const InputDecoration(
              border: OutlineInputBorder(borderSide: BorderSide()),
              labelText: "Description",
              floatingLabelBehavior: FloatingLabelBehavior.always),
        ));
  }

  Widget dueDateSelector() {
    return InputDecorator(
        decoration: const InputDecoration(
            labelText: "Due Date", border: OutlineInputBorder()),
        child: TableCalendar(
          focusedDay: selectedDueDate,
          firstDay: DateTime.utc(selectedDueDate.year - 1, 1, 1).toLocal(),
          lastDay: DateTime.utc(selectedDueDate.year + 1, 12, 31).toLocal(),
          onDaySelected: (day, _) {
            if (!isSameDay(selectedDueDate, day)) {
              setState(() {
                selectedDueDate = day;
              });
            }
          },
          selectedDayPredicate: (day) {
            return isSameDay(selectedDueDate, day);
          },
          headerStyle: const HeaderStyle(
              headerPadding: EdgeInsets.symmetric(vertical: 0.0),
              titleCentered: true,
              titleTextStyle: TextStyle(fontSize: 14.0),
              leftChevronMargin: EdgeInsets.zero,
              rightChevronMargin: EdgeInsets.zero,
              formatButtonVisible: false),
          daysOfWeekStyle: const DaysOfWeekStyle(
              weekdayStyle: TextStyle(fontSize: 12.0),
              weekendStyle: TextStyle(fontSize: 12.0)),
          daysOfWeekHeight: 28.0,
          calendarStyle: const CalendarStyle(
              isTodayHighlighted: false,
              outsideTextStyle: TextStyle(fontSize: 12.0),
              weekendTextStyle: TextStyle(fontSize: 12.0),
              defaultTextStyle: TextStyle(fontSize: 12.0)),
          rowHeight: 36.0,
          calendarBuilders: CalendarBuilders(
            selectedBuilder: (context, date, events) => Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Theme.of(context).iconTheme.color,
                    shape: BoxShape.circle),
                child: Text(
                  date.day.toString(),
                  style: TextStyle(
                      fontSize: 12.0, color: Theme.of(context).primaryColor),
                )),
          ),
        ));
  }

  Widget submitButtons() {
    return Row(children: [
      const Spacer(),
      TextButton(
          child: Padding(
              padding: const EdgeInsets.all(15),
              child: Text(widget.addOrEdit == "Add" ? "Cancel" : "Discard")),
          onPressed: () {
            titleController.clear();
            Navigator.of(context).pop();
          }),
      TextButton(
          child: Padding(
              padding: const EdgeInsets.all(15),
              child: Text(widget.addOrEdit == "Add" ? "Add" : "Save")),
          onPressed: () {
            if (widget.addOrEdit == "Add") {
              widget.taskManager.addTask(Task(titleController.text,
                  descriptionController.text, selectedDueDate));
              titleController.clear();
              descriptionController.clear();
            } else if (widget.addOrEdit == "Edit") {
              String? newTitle = titleController.text == widget.task.title
                  ? null
                  : titleController.text;
              String? newDescription =
                  descriptionController.text == widget.task.description
                      ? null
                      : descriptionController.text;
              DateTime? newDueDate = selectedDueDate == widget.task.dueDate
                  ? null
                  : selectedDueDate;
              widget.taskManager.updateTask(
                  widget.task, newTitle, newDescription, newDueDate);
              titleController.clear();
              descriptionController.clear();
            }
            Navigator.of(context).pop();
          })
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${widget.addOrEdit} Task"),
                      titleInput(),
                      descriptionInput(),
                      dueDateSelector(),
                      submitButtons(),
                    ]))));
  }
}
