import 'package:beautyminder/pages/todo/viewmodel/todo_view_model.dart';
import 'package:beautyminder/pages/todo/widgets/pop_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:beautyminder/pages/todo/update_todo_page.dart';
import 'package:beautyminder/pages/todo/viewmodel/page_view_model.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late DateTime _focusedDay;
  late DateTime _selectedDate;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _calendar(),
            Expanded(
              child: ListView(
                children: _buildTodoSection(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _calendar() {
    return TableCalendar(
      firstDay: DateTime.utc(2020, 10, 16),
      lastDay: DateTime.utc(2030, 3, 14),
      focusedDay: _focusedDay,
      calendarFormat: _calendarFormat,
      selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
      onDaySelected: (selectedDay, focusedDay) {
        final pageViewModel = context.read<PageViewModel>();
        pageViewModel.changeSelectedDate(selectedDay);
        setState(() {
          _selectedDate = selectedDay;
          _focusedDay = focusedDay;
        });
      },
      onFormatChanged: (format) {
        if (_calendarFormat != format) {
          setState(() {
            _calendarFormat = format;
          });
        }
      },
      calendarBuilders: CalendarBuilders(
        selectedBuilder: (context, date, events) => Container(
          margin: const EdgeInsets.all(4.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Text(
            date.day.toString(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        todayBuilder: (context, date, events) => Container(
          margin: const EdgeInsets.all(4.0),
          alignment: Alignment.center,
          child: Text(
            date.day.toString(),
            style: const TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildTodoSection() {
    var morningList = _buildTodoList('morning');
    var eveningList = _buildTodoList('evening');

    List<Widget> todoSections = [];

    if (morningList != null) {
      todoSections.addAll([
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
                child: const Center(
                  child: Text('morning'),
                ),
              ),
            ),
          ],
        ),
        morningList,
      ]);
    }

    if (eveningList != null) {
      todoSections.addAll([
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
                child: const Center(
                  child: Text('evening'),
                ),
              ),
            ),
          ],
        ),
        eveningList,
      ]);
    }

    if (todoSections.isEmpty) {
      return [
        const Center(
          child: Text('할 일이 없습니다.'),
        )
      ];
    }

    return todoSections;
  }

  Widget? _buildTodoList(String timeOfDay) {
    final todoViewModel = context.watch<TodoViewModel>();

    final todos = todoViewModel.getSelectedDateWithTimeTodos(
      selectedDate: _selectedDate,
      morningOrEvening: timeOfDay,
    );

    if (todos.isEmpty) return null;

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: todos.length,
      itemBuilder: (context, index) {
        return Slidable(
          key: Key(todos[index].id.toString()),
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
                        id: todos[index].id,
                        todo: todos[index],
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
              todoViewModel.deleteTodo(todos[index].id);
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
                    todoViewModel.deleteTodo(todos[index].id);
                  }
                },
              ),
            ],
          ),
          child: ListTile(
            title: Text(
              todos[index].name,
              style: TextStyle(
                decoration:
                    todos[index].isFinished ? TextDecoration.lineThrough : null,
              ),
            ),
            leading: Checkbox(
              value: todos[index].isFinished,
              onChanged: (bool? newValue) {
                todoViewModel.toggleIsFinished(
                    todos[index].id, !todos[index].isFinished);
              },
            ),
            onTap: () {
              todoViewModel.toggleIsFinished(
                  todos[index].id, !todos[index].isFinished);
            },
          ),
        );
      },
    );
  }
}
