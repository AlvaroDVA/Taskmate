import 'dart:convert';
import 'dart:io';

import 'package:taskmate_app/models/user.dart';

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

  Future<void> deleteUser(User? currentUser) async {
    String url = "${appConfig.urlApi}/users";

    if (currentUser != null) {
      Map<String, String> userData = {
        'idUser': currentUser.idUser,
      };

      Map<String, String> headers = {
        'username': currentUser.username,
        'password': currentUser.password,
        'Content-Type': 'application/json',
      };

      http.Response response = await http.delete(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(userData),
      );

      if (response.statusCode == 200) {
        print('Usuario eliminado correctamente');
      } else {
        print('Error al eliminar el usuario: ${response.statusCode}');
      }
    }

  }

  Future<void> updateAvatar(User? currentUser) async {
    String url = "${appConfig.urlApi}/users";

    if (currentUser != null) {
      List<int> imageBytes = await currentUser.avatar.readAsBytes();
      String base64Image = base64Encode(imageBytes);

      // Cuerpo de la solicitud
      Map<String, dynamic> body = {
        'idUser': currentUser.idUser,
        'avatar': base64Image,
      };

      // Encabezados de la solicitud
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'username': currentUser.username,
        'password': currentUser.password,
      };

      try {
        http.Response response = await http.put(
          Uri.parse(url),
          headers: headers,
          body: jsonEncode(body),
        );

        if (response.statusCode == 200) {
          print('Avatar actualizado correctamente');
        } else {
          print('Error al actualizar el avatar: ${response.body}');
        }
      } catch (error) {
        print('Error al realizar la solicitud: $error');
      }
    }
  }
}