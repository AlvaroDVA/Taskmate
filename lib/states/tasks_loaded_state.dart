import 'package:flutter/cupertino.dart';
import 'package:taskmate_app/controllers/day_controller.dart';
import 'package:taskmate_app/services/service_locator.dart';
import 'package:taskmate_app/states/auth_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/day.dart';

class TasksLoadedState extends ChangeNotifier {

  final DayController _dayController = ServiceLocator.dayController;
  final AuthState _authState = ServiceLocator.authState;

  Day? _currentDay;
  String? _errorMessage;

  String? get errorMessage => _errorMessage;
  Day get currentDay => _currentDay ?? Day(date: DateTime.now(), todayTasks: [], loaded: false);

  bool isLoaded = false;

  TasksLoadedState() {
    loadCurrentDay(DateTime.now());
  }

  Future<void> loadCurrentDay(DateTime dateTime) async {
    _authState.checkIsLogged();
    isLoaded = false;
    notifyListeners();
    if (_authState.isLogged && _authState.currentUser != null) {
      _currentDay = await _dayController.loadDayTasks(_authState.currentUser!, dateTime);
    } else {
      _currentDay = Day (
          date : currentDay.date,
          loaded: false,
          todayTasks: []
      );
    }
    notifyListeners();
    isLoaded = true;
  }

  Future<void> setCurrentDay (DateTime date) async {
    await loadCurrentDay(date);
    notifyListeners();
  }

  void setErrorMessage (String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  Future<void> saveCurrentTask() async {
    await _dayController.saveDay(currentDay, _authState.currentUser);
  }

}