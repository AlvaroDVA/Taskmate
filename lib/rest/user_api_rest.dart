import 'dart:convert';
import 'dart:io';

import '../config/app_config.dart';
import '../services/service_locator.dart';
import 'package:http/http.dart' as http;

class UserApiRest {

  final AppConfig appConfig = ServiceLocator.appConfig;

  Future<Map<String, dynamic>> loginUser (String username, String password) async {

    String url = "${appConfig.urlApi}/login";
    final response = await http.get(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json','username': username, 'password': password},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al iniciar sesión: ${response.reasonPhrase}');
    }
  }

  Future <Map<String,dynamic>> registerUser( String uuid, String username,
      String password, String email, File avatar) async{

    String url = "${appConfig.urlApi}/users";

    Map<String,dynamic> data = {
      'idUser' : uuid,
      'username' : username,
      'password' : password,
      'email' : email,
      'avatar' : await encodeFile(avatar)
    };


    final response = await http.post(
      Uri.parse(url),
      headers : {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al registrar usuario: ${response.reasonPhrase}');
    }

  }

  Future<String> encodeFile(File avatar) async {
    List<int> avatarBytes = await avatar.readAsBytes();
    String avatarBase64 = base64Encode(avatarBytes);
    return avatarBase64;
  }
}