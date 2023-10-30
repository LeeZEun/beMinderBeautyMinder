import 'package:beautyminder/pages/home_page.dart';
import 'package:beautyminder/pages/hot_page.dart';
import 'package:beautyminder/pages/my/my_page.dart';
import 'package:beautyminder/pages/pouch_page.dart';
import 'package:beautyminder/pages/todo/todo_body_page.dart';
import 'package:beautyminder/widget/commonBottomNavigationBar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/Utils.dart';
import '../../widget/commonAppBar.dart';
import 'viewmodel/page_view_model.dart';
import 'add_todo_page.dart';
import 'calendar_page.dart';

class TodoPage extends StatelessWidget {
  const TodoPage({Key? key}) : super(key: key);
  final int _currentIndex = 3;

  @override
  Widget build(BuildContext context) {
    final pageViewModel = context.watch<PageViewModel>();
    return Scaffold(
      appBar: CommonAppBar(),
      body:
          pageViewModel.showCalendar ? const CalendarPage() : const TodoBodyPage(),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            heroTag: 'toggle',
            onPressed: () {
              context.read<PageViewModel>().toggleView();
            },
            child: pageViewModel.showCalendar
                ? const Icon(Icons.list_alt_sharp)
                : const Icon(Icons.calendar_month),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: 'addTodo',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      AddTodoPage(selectedDate: pageViewModel.selectedDate),
                ),
              );
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
      bottomNavigationBar: CommonBottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (int index) {
            commonOnTapBottomNavigationBar(index, _currentIndex, context);
          }

      ),
    );
  }
}
