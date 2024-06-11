import 'dart:convert';

import 'package:crypto/crypto.dart';

class AuthService {

  static String hashPassword(String password) {
    final salt = List<int>.generate(16, (index) => index);

    final bytes = utf8.encode(password);
    final hashedBytes = sha256.convert([...salt, ...bytes]);
    return hashedBytes.toString();
  }

}