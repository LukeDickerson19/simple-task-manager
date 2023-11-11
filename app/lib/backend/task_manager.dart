import 'dart:convert';
import 'package:flutter/material.dart';
import 'storage_manager.dart';

class TaskManager with ChangeNotifier {
  List<Task> tasks = [];
  final String filepath = "tasks.json";
  String readTasksMessage = "loading tasks";

  TaskManager() {
    loadTasks();
  }

  Future<void> loadTasks() async {
    String? fileContents;
    try {
      fileContents = await StorageManager.readFile(filepath);
      if (fileContents == null) {
        readTasksMessage = "no tasks to do";
      } else {
        for (final taskJsonStr in jsonDecode(fileContents)) {
          tasks.add(Task.fromJson(taskJsonStr));
        }
        if (tasks.isEmpty) {
          readTasksMessage = "no tasks to do";
        }
      }
    } catch (e) {
      readTasksMessage = "failed to read tasks";
    }
    notifyListeners();
  }

  Future<void> saveTasks() async {
    await StorageManager.saveFile(filepath, jsonEncode(tasks));
  }

  void addTask(Task task) {
    tasks.add(task);
    tasks.sort((a, b) => a.compareTo(b));
    notifyListeners();
    saveTasks();
  }

  void deleteTask(Task task) {
    tasks.remove(task);
    notifyListeners();
    saveTasks();
  }

  void updateTask(
      Task task, String? title, String? description, DateTime? dueDate) {
    int i = tasks.indexOf(task);
    if (title != null) {
      tasks[i].title = title;
    }
    if (description != null) {
      tasks[i].description = description;
    }
    if (dueDate != null) {
      tasks[i].dueDate = dueDate;
    }
    tasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    notifyListeners();
    saveTasks();
  }
}

class Task {
  String title, description;
  DateTime dueDate;

  Task(this.title, this.description, this.dueDate);

  Task.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        description = json['description'],
        dueDate = DateTime.fromMillisecondsSinceEpoch(json['dueDate']);

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'dueDate': dueDate.millisecondsSinceEpoch,
    };
  }

  int compareTo(Task task) {
    int dueDateComparison = dueDate.compareTo(task.dueDate);
    if (dueDateComparison != 0) {
      return dueDateComparison;
    } else {
      return title.compareTo(task.title);
    }
  }
}
