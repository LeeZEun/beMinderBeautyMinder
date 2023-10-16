import 'package:beautyminder/models/todo_model.dart';
import 'package:beautyminder/repository/repository.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:table_calendar/table_calendar.dart';

class TodoViewModel extends ChangeNotifier {
  List<TodoModel> _todoList = [];
  get todoList => _todoList;

  final _todoRepository = GetIt.I.get<TodoRepository>();

  int get newId {
    return DateTime.now().millisecondsSinceEpoch;
  }

  Future<void> getTodos() async {
    _todoList = await _todoRepository.getTodos();
    notifyListeners();
  }

  Future<void> addTodo({
    required String cosmeticName,
    required DateTime selectedDate,
    required String morningOrEvening,
    required String? imagePath,
  }) async {
    final newTodo = TodoModel(
      id: newId,
      name: cosmeticName,
      date: selectedDate,
      morningOrEvening: morningOrEvening,
      imagePath: imagePath,
    );

    await _todoRepository.addTodo(newTodo);
    getTodos();
  }

  Future<void> updateTodo({
    required int id,
    required String cosmeticName,
    required DateTime selectedDate,
    required String morningOrEvening,
    required bool isFinished,
    required String? imagePath,
  }) async {
    await _todoRepository.updateTodo(
      id,
      TodoModel(
        id: id,
        name: cosmeticName,
        date: selectedDate,
        morningOrEvening: morningOrEvening,
        isFinished: isFinished,
        imagePath: imagePath,
      ),
    );
    getTodos();
  }

  Future<void> deleteTodo(int id) async {
    await _todoRepository.deleteTodo(id);
    getTodos();
  }

  Future<void> toggleIsFinished(int id, bool currentIsFinished) async {
    await _todoRepository.toggleIsFinished(id, currentIsFinished);
    getTodos();
  }

  List<TodoModel> getSelectedDateWithTimeTodos({
    required DateTime selectedDate,
    required String morningOrEvening,
  }) {
    return todoList
        .where((todo) =>
            isSameDay(todo.date, selectedDate) &&
            todo.morningOrEvening == morningOrEvening)
        .toList();
  }
}
