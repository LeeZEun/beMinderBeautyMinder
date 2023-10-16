import 'package:beautyminder/models/todo_model.dart';
import 'datasource/interface/todo_datasource.dart';

class TodoRepository {
  final TodoDatasource _todoDatasource;

  TodoRepository(this._todoDatasource);

  Future<List<TodoModel>> getTodos() async {
    return await _todoDatasource.getTodos();
  }

  Future<void> addTodo(TodoModel todo) async {
    return await _todoDatasource.addTodo(todo);
  }

  Future<void> updateTodo(int id, TodoModel newTodo) async {
    return await _todoDatasource.updateTodo(id, newTodo);
  }

  Future<void> deleteTodo(int id) async {
    return await _todoDatasource.deleteTodo(id);
  }

  Future<void> toggleIsFinished(int id, bool currentIsFinished) async {
    final newIsFinished = currentIsFinished == true ? 1 : 0;
    return await _todoDatasource.toggleIsFinished(id, newIsFinished);
  }
}
