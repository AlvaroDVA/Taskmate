import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskmate_app/config/app_config.dart';
import 'package:taskmate_app/controllers/day_controller.dart';
import 'package:taskmate_app/controllers/user_controller.dart';
import 'package:taskmate_app/models/user.dart';
import 'package:taskmate_app/rest/tasks_api_rest.dart';
import 'package:taskmate_app/rest/user_api_rest.dart';
import 'package:taskmate_app/services/day_service.dart';
import 'package:taskmate_app/services/user_service.dart';
import 'package:taskmate_app/states/tasks_loaded_state.dart';

import '../states/auth_state.dart';

class ServiceLocator {
  static final UserController _userController = UserController();
  static final UserService _userService = UserService();
  static final AppConfig _appConfig = AppConfig();
  static final UserApiRest _userApiRest = UserApiRest();
  static final DayController _dayController = DayController();
  static final DayService _dayService = DayService();
  static final TasksApiRest _tasksApiRest = TasksApiRest();
  static AuthState? _authState;

  static UserController get userController => _userController;
  static UserService get userService => _userService;
  static AppConfig get appConfig => _appConfig;
  static UserApiRest get userApiRest => _userApiRest;
  static DayController get dayController => _dayController;
  static DayService get dayService => _dayService;
  static TasksApiRest get tasksApiRest => _tasksApiRest;
  static AuthState get authState  {
    if (_authState != null) {
      return _authState!;
    }else {
      return AuthState();
    }
  }
  static void setAuthState(AuthState authState) => _authState = authState;
}