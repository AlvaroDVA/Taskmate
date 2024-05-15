import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskmate_app/ui/pages/login_screen.dart';
import 'package:uuid/uuid.dart';

import '../../config/app_config.dart';
import '../../controllers/user_controller.dart';
import '../../main.dart';
import '../../models/user.dart';
import '../../services/service_locator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../states/auth_state.dart';
import '../../utils/utils.dart';
import '../widgets/forms_widgets/error_box.dart';
import '../widgets/forms_widgets/form_submit_button.dart';
import '../widgets/forms_widgets/link_form.dart';
import '../widgets/forms_widgets/text_block_form.dart';
import 'day_task_screen.dart';

class RegisterScreen extends StatelessWidget {
  
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController repeatPasswordController = TextEditingController();
  final UserController userController = ServiceLocator.userController;
  final AppConfig appConfig = ServiceLocator.appConfig;

  @override
  Widget build(BuildContext context) {
    double paddingValue = 20.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.registerText),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextBlockForm(
                textEditingController: usernameController,
                text: AppLocalizations.of(context)!.username,
                isHiddenText: false
            ),
            TextBlockForm(
                textEditingController: emailController,
                text: AppLocalizations.of(context)!.email,
                isHiddenText: false
            ),
            TextBlockForm(textEditingController: passwordController,
                text: AppLocalizations.of(context)!.password,
                isHiddenText: true
            ),
            TextBlockForm(textEditingController: repeatPasswordController,
                text: AppLocalizations.of(context)!.repeatPassword,
                isHiddenText: true
            ),
            const ErrorBox(),
            Padding(
              padding: EdgeInsets.all(paddingValue),
              child: FormSubmitButton(
                onPressed: () async{
                  submiteRegister(context);
                },
                textButton: AppLocalizations.of(context)!.registerText,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(paddingValue),
              child: LinkForm(
                textNotLink : AppLocalizations.of(context)!.loginUserTextNotLink,
                textLink:  AppLocalizations.of(context)!.loginUserLink,
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
              ),
            )
          ],
        )
      ),
    );
  }

  void submiteRegister(BuildContext context) {
    final authState = Provider.of<AuthState>(context, listen: false);
    if (usernameController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        repeatPasswordController.text.isNotEmpty
    ) {
      registerForm(context, authState);
    } else {
      authState.setErrorMessage(AppLocalizations.of(context)!.emptyFields);
    }
  }

  void registerForm(BuildContext context, AuthState authState) async {
    if (passwordController.text != repeatPasswordController.text) {
      var errorMessage = Utils.getFormsErrorMessage(
        "1004", context
      );
      authState.setErrorMessage(errorMessage);
    } else {
      var res = await userController.registerUser(
        const Uuid().v1(),
        usernameController.text,
        passwordController.text,
        emailController.text,
        await Utils.getBasicAvatar()
      );
      if (res['error'] != null) {
        incorrectRegister(res, context, authState);
      } else {
        correctLogin(authState, res, context);
      }
    }
  }

  void incorrectRegister(Map<String, dynamic> res, BuildContext context, AuthState authState) {
    var errorCode = res['error'];
    var errorMessage = Utils.getFormsErrorMessage(
        errorCode.toString(),
        context
    );
    authState.setErrorMessage(errorMessage);
  }

  void correctLogin(AuthState authState, Map<String, dynamic> res, BuildContext context) async {
    authState.isLogged = true;
    authState.setCurrentUser(
        User(
          idUser : res['_id'],
          username : res['username'],
          password: res['password'],
          email : res['email'],
          avatar: await Utils.fileFromBytes(res['avatar']),
        )
    );
    authState.setErrorMessage(null);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => DayTaskScreen()),
    );
  }

}