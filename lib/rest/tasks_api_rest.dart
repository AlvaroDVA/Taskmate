import 'dart:convert';
import 'dart:io';

import 'package:taskmate_app/models/day.dart';
import 'package:taskmate_app/states/auth_state.dart';

import '../config/app_config.dart';
import '../models/user.dart';
import '../services/service_locator.dart';
import 'package:http/http.dart' as http;

class TasksApiRest {

  final AppConfig appConfig = ServiceLocator.appConfig;
  final AuthState authState = ServiceLocator.authState;

  Future<Map<String, dynamic>> getDayTasks(User user, String day) async {
    String url = "${appConfig.urlApi}/tasks";

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json; charset=UTF-8',
          'username': user.username,
          'password': user.password, 'idUser' : user.idUser, 'date' : day.toString()},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }else {
        throw Exception('Error al recuperar las tareas: ${response.reasonPhrase}');
      }
    } on SocketException {
      authState.logoutUser();
      authState.setApiError(true);
      return {"" : ""};
    }

  }

  Future<void> saveTasksFromDay(Day currentDay, User user) async{
    String url = "${appConfig.urlApi}/tasks";

    try {
      Map<String,dynamic> body = currentDay.toJson(currentDay);
      await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json; charset=UTF-8',
          'username': user.username,
          'password': user.password},
        body: jsonEncode(<String,dynamic> {
          'idUser' : user.idUser,
          'date' : body['date'],
          'tasks' : body['todayTasks']
        }),
      );
    } on SocketException {
      authState.logoutUser();
      authState.setApiError(true);
    }


  }

}