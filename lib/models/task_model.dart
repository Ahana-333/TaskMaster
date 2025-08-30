import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../services/storage_service.dart';
import '../services/notification_service.dart';

class Task {
  String id;
  String title;
  String? description;
  DateTime? dueDate;
  int priority; // 0 low, 1 medium, 2 high
  String category; // work, personal, study...
  bool isCompleted;
  bool isSnoozed;

  Task({
    String? id,
    required this.title,
    this.description,
    this.dueDate,
    this.priority = 1,
    this.category = 'general',
    this.isCompleted = false,
    this.isSnoozed = false,
  }) : id = id ?? Uuid().v4();

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      priority: json['priority'] ?? 1,
      category: json['category'] ?? 'general',
      isCompleted: json['isCompleted'] ?? false,
      isSnoozed: json['isSnoozed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'dueDate': dueDate?.toIso8601String(),
        'priority': priority,
        'category': category,
        'isCompleted': isCompleted,
        'isSnoozed': isSnoozed,
      };
}

class TaskModel extends ChangeNotifier {
  List<Task> _tasks = [];

  List<Task> get tasks => List.unmodifiable(_tasks);

  // Basic CRUD
  Future<void> addTask(Task task, {bool scheduleNotification = true}) async {
    _tasks.add(task);
    await _save();
    if (scheduleNotification && task.dueDate != null) {
      NotificationService().scheduleNotificationForTask(task);
    }
    notifyListeners();
  }

  Future<void> updateTask(Task updated, {bool rescheduleNotification = true}) async {
    int idx = _tasks.indexWhere((t) => t.id == updated.id);
    if (idx != -1) {
      _tasks[idx] = updated;
      await _save();
      if (rescheduleNotification) {
        NotificationService().cancelNotification(int.parse(updated.id.hashCode.toString().substring(0, 6)));
        if (updated.dueDate != null) {
          NotificationService().scheduleNotificationForTask(updated);
        }
      }
      notifyListeners();
    }
  }

  Future<void> deleteTask(String id) async {
    final t = _tasks.firstWhere((t) => t.id == id, orElse: () => null as Task);
    if (t.dueDate != null) {
      NotificationService().cancelNotification(int.parse(t.id.hashCode.toString().substring(0, 6)));
    }
    _tasks.removeWhere((t) => t.id == id);
    await _save();
    notifyListeners();
  }

  Future<void> toggleComplete(String id) async {
    int idx = _tasks.indexWhere((t) => t.id == id);
    if (idx != -1) {
      _tasks[idx].isCompleted = !_tasks[idx].isCompleted;
      await _save();
      notifyListeners();
    }
  }

  Future<void> _save() async {
    final jsonList = _tasks.map((t) => t.toJson()).toList();
    await StorageService().saveTasks(jsonEncode(jsonList));
  }

  Future<void> loadTasksFromStorage() async {
    final jsonString = StorageService().loadTasks();
    if (jsonString != null) {
      final data = jsonDecode(jsonString) as List<dynamic>;
      _tasks = data.map((e) => Task.fromJson(Map<String, dynamic>.from(e))).toList();
      notifyListeners();
    }
  }

  // Sorting and Filtering helpers
  List<Task> tasksSorted({String sortBy = 'due', String? category}) {
    List<Task> list = List.from(_tasks);
    if (category != null) {
      list = list.where((t) => t.category == category).toList();
    }
    if (sortBy == 'due') {
      list.sort((a, b) {
        if (a.dueDate == null && b.dueDate == null) return 0;
        if (a.dueDate == null) return 1;
        if (b.dueDate == null) return -1;
        return a.dueDate!.compareTo(b.dueDate!);
      });
    } else if (sortBy == 'priority') {
      list.sort((a, b) => b.priority.compareTo(a.priority));
    }
    return list;
  }
}
