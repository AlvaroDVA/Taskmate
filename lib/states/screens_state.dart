import 'package:flutter/cupertino.dart';
import 'package:taskmate_app/ui/pages/day_task_screen.dart';

import '../ui/pages/calendar_screen.dart';
import '../ui/pages/notebook_screen.dart';
import '../ui/pages/settings_page.dart';

class ScreenState extends ChangeNotifier {

  late Widget? _actualScreen;
  DayTaskScreen _dayTaskScreen = DayTaskScreen();
  SettingsScreeen _settingsScreen = SettingsScreeen();
  CalendarScreen _calendarScreen = CalendarScreen();
  NotebookScreen _notebookScreen = NotebookScreen();

  ScreenState() {
    _actualScreen = _dayTaskScreen;
  }

  DayTaskScreen get dayTaskScreen => _dayTaskScreen;
  SettingsScreeen get settingScreen => _settingsScreen;
  CalendarScreen get calendarScreen => _calendarScreen;

  Widget get actualScreen {
    return _actualScreen ?? _dayTaskScreen;
  }

  Future<void> setTaskScreen() async {
    _actualScreen = _dayTaskScreen;
    notifyListeners();
  }

  Future<void> setSettingsScreen() async {
    _actualScreen = _settingsScreen;
    notifyListeners();
  }

  Future<void> clearScreen() async {
    _dayTaskScreen = DayTaskScreen();
    _settingsScreen = SettingsScreeen();
    _actualScreen = _dayTaskScreen;
    notifyListeners();
  }

  Future<void> setCalendarScreen() async {
    _actualScreen = _calendarScreen;
    notifyListeners();
  }

  Future<void> setNotebookScreen() async {
    _actualScreen = _notebookScreen;
    notifyListeners();
  }


}