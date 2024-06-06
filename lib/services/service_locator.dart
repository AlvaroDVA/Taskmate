import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskmate_app/config/app_config.dart';
import 'package:taskmate_app/controllers/day_controller.dart';
import 'package:taskmate_app/controllers/notebook_controller.dart';
import 'package:taskmate_app/controllers/user_controller.dart';
import 'package:taskmate_app/models/user.dart';
import 'package:taskmate_app/rest/notebook_api_rest.dart';
import 'package:taskmate_app/rest/tasks_api_rest.dart';
import 'package:taskmate_app/rest/user_api_rest.dart';
import 'package:taskmate_app/services/day_service.dart';
import 'package:taskmate_app/services/notebook_service.dart';
import 'package:taskmate_app/services/user_service.dart';
import 'package:taskmate_app/states/screens_state.dart';
import 'package:taskmate_app/states/tasks_loaded_state.dart';

import '../states/auth_state.dart';
import '../states/notebook_state.dart';

class ServiceLocator {
  static final UserController _userController = UserController();
  static final UserService _userService = UserService();
  static final AppConfig _appConfig = AppConfig();
  static final UserApiRest _userApiRest = UserApiRest();
  static final DayController _dayController = DayController();
  static final DayService _dayService = DayService();
  static final TasksApiRest _tasksApiRest = TasksApiRest();
  static ScreenState _screenState = ScreenState();
  static TasksLoadedState _tasksLoadedState = TasksLoadedState();
  static AuthState _authState = AuthState();
  static NotebookState _notebookState = NotebookState();
  static NotebookController _notebookController = NotebookController();
  static NotebookService _notebookService = NotebookService();
  static NotebookApiRest _notebookApiRest = NotebookApiRest();

  static UserController get userController => _userController;
  static UserService get userService => _userService;
  static AppConfig get appConfig => _appConfig;
  static UserApiRest get userApiRest => _userApiRest;
  static DayController get dayController => _dayController;
  static DayService get dayService => _dayService;
  static TasksApiRest get tasksApiRest => _tasksApiRest;
  static ScreenState get screenState => _screenState;
  static TasksLoadedState get taskLoadedState => _tasksLoadedState;
  static AuthState get authState => _authState;
  static NotebookState get notebookState => _notebookState;
  static NotebookController get notebookController => _notebookController;
  static NotebookService get notebookService => _notebookService;
  static NotebookApiRest get notebookApiRest => _notebookApiRest;

}