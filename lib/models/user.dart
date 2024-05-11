import 'package:uuid/uuid.dart';

class User {

  Uuid idUser;
  String username;
  String email;
  String avatarUri;

  User ( {
    required this.idUser,
    required this.username,
    required this.email,
    required this.avatarUri
  });
}