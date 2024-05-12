import 'dart:convert';

import '../config/app_config.dart';
import '../services/service_locator.dart';
import 'package:http/http.dart' as http;

class UserApiRest {

  final AppConfig appConfig = ServiceLocator.appConfig;

  Future<Map<String, dynamic>> loginUser (String username, String password) async {

    String url = "${appConfig.urlApi}/login";
    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode({}),
      headers: {'Content-Type': 'application/json','username': username, 'password': password},
    );

    if (response.statusCode == 200) {
      print(response.body);
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al iniciar sesión: ${response.reasonPhrase}');
    }
  }
}