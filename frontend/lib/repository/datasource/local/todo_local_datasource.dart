import 'package:beautyminder/models/todo_model.dart';
import 'package:beautyminder/repository/datasource/datasource.dart';
import 'package:beautyminder/repository/datasource/local/database_helper.dart';

import 'package:sqflite/sqflite.dart';

class TodoLocalDatasource implements TodoDatasource {
  final dbHelper = DatabaseHelper.instance;

  @override
  Future<List<TodoModel>> getTodos() async {
    Database db = await dbHelper.database;
    final List<Map<String, dynamic>> todos =
        await db.query(DatabaseHelper.todoTable);
    return todos.map((e) => TodoModel.fromJson(e)).toList();
  }

  @override
  Future<void> addTodo(TodoModel todo) async {
    Database db = await dbHelper.database;
    await db.insert(DatabaseHelper.todoTable, todo.toJson());
  }

  @override
  Future<void> updateTodo(int id, TodoModel newTodo) async {
    Database db = await dbHelper.database;
    await db.update(
      DatabaseHelper.todoTable,
      newTodo.toJson(),
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<void> deleteTodo(int id) async {
    Database db = await dbHelper.database;
    await db.delete(
      DatabaseHelper.todoTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<void> toggleIsFinished(int id, int newIsFinished) async {
    Database db = await dbHelper.database;
    await db.update(
      DatabaseHelper.todoTable,
      {'isFinished': newIsFinished},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<void> updateSpecificTask() async {}
}
