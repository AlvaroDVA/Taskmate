import 'dart:convert';
import 'dart:io';

import 'package:taskmate_app/models/notebook_page.dart';
import 'package:taskmate_app/models/user.dart';

import '../config/app_config.dart';
import '../services/service_locator.dart';
import '../states/auth_state.dart';
import 'package:http/http.dart' as http;

class NotebookApiRest {

  final AppConfig _appConfig = ServiceLocator.appConfig;
  final AuthState _authState = ServiceLocator.authState;

  Future<Map<String, dynamic>> getAllPages(User currentUser) async {
    String url = "${_appConfig.urlApi}/notebook";

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json; charset=UTF-8',
          'username': currentUser.username,
          'password': currentUser.password,
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }else {
        throw Exception('Error al recuperar las tareas: ${response.reasonPhrase}');
      }
    } on SocketException {
      _authState.logoutUser();
      _authState.setApiError(true);
      return {"" : ""};
    }
  }

  Future<void> saveAllPages(List<NotebookPage> pages, User currentUser) async {
    String url = "${_appConfig.urlApi}/notebook";
    print("Guardando notebook");
    try {
      List<Map<String, dynamic>> list = [];
      pages.forEach((page) {
        list.add(page.toJson());
      });

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'username': currentUser.username,
          'password': currentUser.password,
        },
        body: jsonEncode({
          "pages": list,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to save pages');
      }

    } on SocketException {
      _authState.logoutUser();
      _authState.setApiError(true);
    }
  }

}