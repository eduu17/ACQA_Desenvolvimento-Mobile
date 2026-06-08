import 'package:flutter/foundation.dart';

import '../helpers/date_formatters.dart';
import '../models/task.dart';

class TaskController extends ChangeNotifier {
  TaskController() {
    _createDemoTasks();
  }

  final List<Task> _tasks = [];

  List<Task> tasksFor(DateTime date) {
    final day = dateOnly(date);
    final filtered = _tasks.where((task) => isSameDay(task.date, day)).toList();

    filtered.sort((first, second) {
      if (first.completed != second.completed) {
        return first.completed ? 1 : -1;
      }

      return first.title.toLowerCase().compareTo(second.title.toLowerCase());
    });

    return filtered;
  }

  int taskCountFor(DateTime date) => tasksFor(date).length;

  int pendingCountFor(DateTime date) {
    return tasksFor(date).where((task) => !task.completed).length;
  }

  int completedCountFor(DateTime date) {
    return tasksFor(date).where((task) => task.completed).length;
  }

  int taskCountForMonth(DateTime month) {
    return _tasks.where((task) {
      return task.date.year == month.year && task.date.month == month.month;
    }).length;
  }

  void addTask(DateTime date, String title) {
    final cleanTitle = title.trim();

    if (cleanTitle.isEmpty) {
      return;
    }

    _tasks.add(
      Task(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        title: cleanTitle,
        date: dateOnly(date),
      ),
    );
    notifyListeners();
  }

  void removeTask(String id) {
    _tasks.removeWhere((task) => task.id == id);
    notifyListeners();
  }

  void toggleTask(String id) {
    final index = _tasks.indexWhere((task) => task.id == id);

    if (index == -1) {
      return;
    }

    final task = _tasks[index];
    _tasks[index] = task.copyWith(completed: !task.completed);
    notifyListeners();
  }

  void _createDemoTasks() {
    final today = dateOnly(DateTime.now());
    _tasks.addAll([
      Task(id: 'demo-1', title: 'Criar prints do aplicativo', date: today),
      Task(
        id: 'demo-2',
        title: 'Enviar arquivos Dart para o GitHub',
        date: today,
      ),
      Task(
        id: 'demo-3',
        title: 'Revisar requisitos da ACQA',
        date: today,
        completed: true,
      ),
      Task(
        id: 'demo-4',
        title: 'Separar conclusao autoral',
        date: today.add(const Duration(days: 1)),
      ),
    ]);
  }
}
