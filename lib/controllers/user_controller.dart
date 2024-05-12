import 'package:provider/provider.dart';

import '../services/service_locator.dart';
import '../services/user_service.dart';


class UserController {
  final UserService _userService = ServiceLocator.userService;

  Future<Map<String, dynamic>> loginUser(String username, String password) async {

    return await _userService.LoginUser(username, password);
  }
}