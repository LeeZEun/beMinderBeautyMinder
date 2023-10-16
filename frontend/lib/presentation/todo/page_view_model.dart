import 'package:flutter/material.dart';

class PageViewModel extends ChangeNotifier {
  bool _showCalendar = true;
  bool get showCalendar => _showCalendar;

  DateTime _selectedDate = DateTime.now();
  DateTime get selectedDate => _selectedDate;

  void toggleView() {
    _showCalendar = !_showCalendar;
    if (!_showCalendar) {
      _selectedDate = DateTime.now();
    }
    notifyListeners();
  }

  void changeSelectedDate(DateTime date) {
    _selectedDate = date;
  }
}
