import 'package:beautyminder/models/todo_model.dart';

abstract class TodoDatasource {
  Future<List<TodoModel>> getTodos();

  Future<void> addTodo(TodoModel todo);

  Future<void> updateTodo(int id, TodoModel newTodo);

  Future<void> deleteTodo(int id);

  Future<void> toggleIsFinished(int id, int newIsFinished);

  Future<void> updateSpecificTask();
}
