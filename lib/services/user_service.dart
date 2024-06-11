import 'dart:io';

import 'package:taskmate_app/config/app_config.dart';
import 'package:taskmate_app/models/user.dart';
import 'package:taskmate_app/rest/user_api_rest.dart';
import 'package:taskmate_app/services/auth_service.dart';
import 'package:taskmate_app/services/service_locator.dart';

class UserService {

  final UserApiRest userApiRest = ServiceLocator.userApiRest;

  Future<Map<String, dynamic>> LoginUser (String username, String password) async {

    String hashPassword = AuthService.hashPassword(password);

    return await userApiRest.loginUser(username, hashPassword);

  }

  Future<Map<String,dynamic>> registerUser(String uuid, String username,
      String password, String email, File avatar) async{

    String hashPassword = AuthService.hashPassword(password);

    return await userApiRest.registerUser(uuid, username, hashPassword, email, avatar);
  }

  Future<void> deleteUser(User? currentUser) async {
    return await userApiRest.deleteUser(currentUser);
  }

  Future<void> updateAvatar(User? currentUser) async {
    await userApiRest.updateAvatar(currentUser);
  }


}