import 'package:uuid/uuid.dart';

class User {

  String idUser;
  String username;
  String email;
  String avatarUri;

  User ( {
    required this.idUser,
    required this.username,
    required this.email,
    required this.avatarUri
  });

  Map<String, dynamic> toJson() {
    return {
      "idUser" : idUser,
      "username" : username,
      "email" : email,
      "avatarUri" : avatarUri
    };
  }

  factory User.fromJson(Map<String, dynamic> json) => User(
    idUser: json['idUser'],
    username: json['username'],
    email: json['email'],
    avatarUri: json['avatarUri']
  );

}