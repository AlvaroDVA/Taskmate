import 'package:flutter/cupertino.dart';
import 'package:taskmate_app/controllers/day_controller.dart';
import 'package:taskmate_app/services/service_locator.dart';
import 'package:taskmate_app/states/auth_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/day.dart';

class TasksLoadedState extends ChangeNotifier {


  final DayController _dayController = ServiceLocator.dayController;
  final AuthState _authState = ServiceLocator.authState;

  Day _currentDay = Day(
    date: DateTime.now(),
    loaded: false,
    todayTasks: [],
  );
  String? _errorMessage;

  String? get errorMessage => _errorMessage;
  Day get currentDay => _currentDay;

  TasksLoadedState() {
    loadCurrentDay(DateTime.now());
  }

  Future<void> loadCurrentDay(DateTime dateTime) async {
    if (_authState.isLogged) {
      _currentDay = await _dayController.loadDayTasks(_authState.currentUser!, dateTime);
    } else {
      // TODO Local Days
      _currentDay = Day (
          date : currentDay.date,
          loaded: false,
          todayTasks: []
      );
    }
    notifyListeners();
  }

  Future<void> setCurrentDay (DateTime date) async {
    await loadCurrentDay(date);
  }

  void setErrorMessage (String? message) {
    _errorMessage = message;
    notifyListeners();
  }

}