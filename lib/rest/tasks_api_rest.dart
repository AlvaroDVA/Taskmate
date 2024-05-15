import 'dart:convert';
import 'dart:io';

import '../config/app_config.dart';
import '../models/task.dart';
import '../models/user.dart';
import '../services/service_locator.dart';
import 'package:http/http.dart' as http;

class TasksApiRest {

  final AppConfig appConfig = ServiceLocator.appConfig;

  Future<Map<String, dynamic>> getDayTasks(User user, String day) async {
    String url = "${appConfig.urlApi}/tasks";

    final response = await http.get(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json','username': user.username,
        'password': user.password, 'idUser' : user.idUser, 'date' : day.toString()},
    );

    if (response.statusCode == 200) {
      print(response.body);
      return jsonDecode(response.body);
    }else {
      throw Exception('Error al recuperar las tareas: ${response.reasonPhrase}');
    }
  }

}