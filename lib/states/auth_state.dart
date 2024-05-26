import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';
import '../utils/utils.dart';

class AuthState extends ChangeNotifier {
  String? _errorMessage;
  User? _currentUser;
  bool _isLogged = false;

  String? get errorMessage => _errorMessage;
  User? get currentUser => _currentUser;
  bool get isLogged => _isLogged;

  AuthState() {
    _initialize();
  }

  Future<void> _initialize() async {
    await checkLoginStatus();
    notifyListeners();
  }

  void setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  Future<void> setCurrentUser(User user) async {
    _currentUser = user;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('idUser', user.idUser);
    await prefs.setString('currentUser', user.username);
    await prefs.setString('password', user.password);
    await prefs.setString('email', user.email);
    await prefs.setString('avatarUri', await user.avatarString());
    await prefs.setBool('isLoggedIn', true);

    _isLogged = true;
    notifyListeners();
  }

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isLogged = prefs.getBool('isLoggedIn') ?? false;

    if (_isLogged) {
      final idUser = prefs.getString('idUser');
      final username = prefs.getString('currentUser');
      final password = prefs.getString('password');
      final email = prefs.getString('email');
      final avatarUri = prefs.getString('avatarUri');

      if (idUser != null && username != null && password != null && email != null && avatarUri != null) {
        _currentUser = User(
          idUser: idUser,
          username: username,
          password: password,
          email: email,
          avatar: await Utils.fileFromBytes(avatarUri),
        );
      } else {
        _isLogged = false;
      }
    }
    print(_currentUser?.username ?? "None");
    notifyListeners();
  }

  void setLogged(bool value) {
    _isLogged = value;
    notifyListeners();
  }

  Future<void> logoutUser() async {
    _isLogged = false;
    notifyListeners();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  @override
  void dispose() {
  }

  Future<bool> checkIsLogged() async => _isLogged;
}
