import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class User {

  String idUser;
  String username;
  String email;
  File avatar;
  String password;

  User ( {
    required this.idUser,
    required this.username,
    required this.password,
    required this.email,
    required this.avatar
  });

  Future<String> avatarString() async {
    List<int> avatarBytes = await avatar.readAsBytes();
    String avatarBase64 = base64Encode(avatarBytes);
    return avatarBase64;
  }

}