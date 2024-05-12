import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskmate_app/config/app_config.dart';
import 'package:taskmate_app/controllers/user_controller.dart';
import 'package:taskmate_app/models/user.dart';
import 'package:taskmate_app/rest/user_api_rest.dart';
import 'package:taskmate_app/services/user_service.dart';

class ServiceLocator {
  static final UserController _userController = UserController();
  static final UserService _userService = UserService();
  static final AppConfig _appConfig = AppConfig();
  static final UserApiRest _userApiRest = UserApiRest();


  static UserController get userController => _userController;
  static UserService get userService => _userService;
  static AppConfig get appConfig => _appConfig;
  static UserApiRest get userApiRest => _userApiRest;

}