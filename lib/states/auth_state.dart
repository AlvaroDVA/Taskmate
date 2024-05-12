import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../models/user.dart';

class AuthState extends ChangeNotifier {
  String? _errorMessage;
  User? _currentUser;
  bool isLogged = false;

  AuthState() {
    checkLoginStatus();
  }

  // Getter para obtener el mensaje de error
  String? get errorMessage => _errorMessage;

  User? get currentUser => _currentUser;

  // Setter para actualizar el mensaje de error
  void setErrorMessage(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  Future<void> setCurrentUser(User user) async {
    _currentUser = user;
    notifyListeners();

    // Guardar la información del usuario en SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('idUser', user.idUser);
    await prefs.setString('currentUser', user.username);
    await prefs.setString('email', user.email);
    await prefs.setString('avatarUri', user.avatarUri);
    await prefs.setBool('isLoggedIn', true);
  }

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool loggedIn = prefs.getBool('isLoggedIn') ?? false;
    isLogged = loggedIn;

    if (loggedIn) {
      _currentUser = User(
        idUser: prefs.getString('idUser')!,
        username: prefs.getString('currentUser')!,
        email: prefs.getString('email')!,
        avatarUri: prefs.getString('avatarUri')!,
      );
    }

    notifyListeners();
  }


  Future<void> logoutUser() async {
    isLogged = false;
    notifyListeners();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
  }

}