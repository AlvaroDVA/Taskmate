import 'dart:io';

import 'package:provider/provider.dart';
import 'package:taskmate_app/models/user.dart';

import '../services/service_locator.dart';
import '../services/user_service.dart';


class UserController {
  final UserService _userService = ServiceLocator.userService;

  Future<Map<String, dynamic>> loginUser(String username, String password) async {

    return await _userService.LoginUser(username, password);
  }

  Future<Map<String, dynamic>> registerUser (String uuid, String username,
    String password, String email, File avatar) async {
      return await _userService.registerUser(
      uuid,username,password,email,avatar
    );
  }

  Future<void> deleteUser(User? currentUser) async {
    return await _userService.deleteUser(currentUser);
  }

  Future<void> updateAvatar(User? currentUser) async {
    await _userService.updateAvar(currentUser);
  }
}