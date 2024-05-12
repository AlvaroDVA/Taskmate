import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskmate_app/controllers/user_controller.dart';
import 'package:taskmate_app/main.dart';
import 'package:taskmate_app/services/service_locator.dart';
import 'package:uuid/uuid.dart';

import '../../config/app_config.dart';
import '../../models/user.dart';
import '../../states/auth_state.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final UserController userController = ServiceLocator.userController;
  final AppConfig appConfig = ServiceLocator.appConfig;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              constraints: BoxConstraints(maxWidth: 400),
              child: TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: 'Usuario',
                ),
              ),
            ),
            Container(
              constraints: BoxConstraints(maxWidth: 400),
              child: TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                ),
                obscureText: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Consumer<AuthState>(
                builder: (context, authState, _) {
                  if (authState.errorMessage != null) {
                    return Text(
                      authState.errorMessage!,
                      style: TextStyle(color: Colors.red),
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                onPressed: () async {
                  final authState = Provider.of<AuthState>(context, listen: false);
                  if (usernameController.text.isNotEmpty && passwordController.text.isNotEmpty) {
                    var res = await userController.loginUser(usernameController.text, passwordController.text);
                    if (res['error'] != null) {
                      var errorCode = res['error'];
                      var errorMessage = appConfig.errorCodes["$errorCode"];
                      if (errorMessage != null) {
                        authState.setErrorMessage(errorMessage);
                      } else {
                        authState.setErrorMessage("Código de error desconocido: $errorCode");
                      }
                    } else {
                      authState.isLogged = true;
                      authState.setCurrentUser(
                          User(
                            idUser : res['_id'],
                            username : res['username'],
                            email : res['email'],
                            avatarUri: res['avatar_uri'],
                          )
                      );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => MyHomePage(title: 'Contador',)),
                      );

                    }
                  } else {
                    authState.setErrorMessage("Por favor, completa todos los campos.");
                  }
                },
                child: Text('Login'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

