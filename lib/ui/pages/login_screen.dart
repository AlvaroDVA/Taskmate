import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskmate_app/controllers/user_controller.dart';
import 'package:taskmate_app/main.dart';
import 'package:taskmate_app/services/service_locator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taskmate_app/ui/pages/day_task_screen.dart';
import 'package:taskmate_app/ui/pages/register_screen.dart';

import '../../config/app_config.dart';
import '../../models/user.dart';
import '../../states/auth_state.dart';
import '../../utils/utils.dart';
import '../widgets/forms_widgets/error_box.dart';
import '../widgets/forms_widgets/form_submit_button.dart';
import '../widgets/forms_widgets/link_form.dart';
import '../widgets/forms_widgets/text_block_form.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final UserController userController = ServiceLocator.userController;
  final AppConfig appConfig = ServiceLocator.appConfig;

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double paddingValue = 20.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.loginText),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextBlockForm(
                textEditingController: usernameController,
                text : AppLocalizations.of(context)!.username ,
                isHiddenText: false
            ),
            TextBlockForm(
                textEditingController: passwordController,
                text : AppLocalizations.of(context)!.password,
                isHiddenText: true
            ),
            const ErrorBox(),
            Padding(
              padding: EdgeInsets.all(paddingValue),
              child: FormSubmitButton(
                onPressed: () async {
                  await submitLogin(context);
                },
                textButton: AppLocalizations.of(context)!.loginText),
              ),
            Padding(
              padding: EdgeInsets.all(paddingValue),
              child: LinkForm(
                textNotLink : AppLocalizations.of(context)!.notAccount,
                textLink:  AppLocalizations.of(context)!.registerUserLink,
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterScreen()),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> submitLogin(BuildContext context) async {
    final authState = Provider.of<AuthState>(context, listen: false);
    if (usernameController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      var res = await userController.loginUser(usernameController.text, passwordController.text);
      if (res['error'] != null) {
        incorrectLogin(res, context, authState);
      } else {
        correctLogin(authState, res, context);
      }
    } else {
      authState.setErrorMessage(AppLocalizations.of(context)!.emptyFields);
    }
  }

  void incorrectLogin(Map<String, dynamic> res, BuildContext context, AuthState authState) {
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







