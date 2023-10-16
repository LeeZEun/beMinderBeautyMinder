import 'package:beautyminder/models/todo_model.dart';
import 'package:beautyminder/pages/todo/update_todo_page.dart';
import 'package:beautyminder/presentation/todo/widgets/pop_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../../presentation/todo/todo_view_model.dart';

class TodoBodyPage extends StatelessWidget {
  const TodoBodyPage({Key? key}) : super(key: key);

  DateTime dateOnly(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  @override
  Widget build(BuildContext context) {
    final todoViewModel = context.watch<TodoViewModel>();

    Map<DateTime, List<TodoModel>> groupedTodos = {};
    for (var todo in todoViewModel.todoList) {
      DateTime dateOnlyKey = dateOnly(todo.date);
      if (!groupedTodos.containsKey(dateOnlyKey)) {
        groupedTodos[dateOnlyKey] = [];
      }
      groupedTodos[dateOnlyKey]!.add(todo);
    }

    List<DateTime> sortedKeys = groupedTodos.keys.toList()
      ..sort((a, b) => a.compareTo(b));

    return Scaffold(
      appBar: AppBar(
        title: const Text('todo'),
      ),
      body: ListView.builder(
        itemCount: sortedKeys.length,
        itemBuilder: (context, index) {
          DateTime dateKey = sortedKeys[index];
          List<Widget> dayTodos = [];

          dayTodos.add(
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '${dateKey.year}년 ${dateKey.month}월 ${dateKey.day}일',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          );

          for (var timeOfDay in ['morning', 'evening']) {
            var todosForTime = groupedTodos[dateKey]!
                .where((todo) => todo.morningOrEvening == timeOfDay)
                .toList();

            if (todosForTime.isNotEmpty) {
              dayTodos.add(
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Container(
                        width: 100,
                        height: 35,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                          child: Text(timeOfDay),
                        ),
                      ),
                    ),
                  ],
                ),
              );

              dayTodos.addAll(todosForTime.map((todo) {
                return Slidable(
                  key: Key(todo.id.toString()),
                  startActionPane: ActionPane(
                    motion: const DrawerMotion(),
                    extentRatio: 0.25,
                    dragDismissible: false,
                    children: [
                      SlidableAction(
                        label: 'Update',
                        backgroundColor: Colors.orange,
                        icon: Icons.archive,
                        onPressed: (context) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => UpdateTodoPage(
                                id: todo.id,
                                todo: todo,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  endActionPane: ActionPane(
                    motion: const DrawerMotion(),
                    extentRatio: 0.25,
                    dragDismissible: false,
                    dismissible: DismissiblePane(onDismissed: () {
                      todoViewModel.deleteTodo(todo.id);
                    }),
                    children: [
                      SlidableAction(
                        label: 'Delete',
                        backgroundColor: Colors.red,
                        icon: Icons.delete,
                        onPressed: (context) async {
                          final ok = await popUp(
                            title: '정말 삭제하시겠습니까?',
                            context: context,
                          );
                          if (ok) {
                            todoViewModel.deleteTodo(todo.id);
                          }
                        },
                      ),
                    ],
                  ),
                  child: ListTile(
                    title: Text(
                      todo.name,
                      style: TextStyle(
                        decoration:
                            todo.isFinished ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    leading: Checkbox(
                      value: todo.isFinished,
                      onChanged: (bool? newValue) {
                        todoViewModel.toggleIsFinished(
                            todo.id, !todo.isFinished);
                      },
                    ),
                    onTap: () {
                      todoViewModel.toggleIsFinished(todo.id, !todo.isFinished);
                    },
                  ),
                );
              }).toList());
            }
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: dayTodos,
          );
        },
      ),
    );
  }
}
