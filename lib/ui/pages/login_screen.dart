import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskmate_app/controllers/user_controller.dart';
import 'package:taskmate_app/main.dart';
import 'package:taskmate_app/services/service_locator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taskmate_app/states/tasks_loaded_state.dart';
import 'package:taskmate_app/ui/pages/day_task_screen.dart';
import 'package:taskmate_app/ui/pages/home_page.dart';
import 'package:taskmate_app/ui/pages/register_screen.dart';
import 'package:window_manager/window_manager.dart';

import '../../config/app_config.dart';
import '../../models/user.dart';
import '../../states/auth_state.dart';
import '../../utils/utils.dart';
import '../widgets/api_error_modal_widget.dart';
import '../widgets/forms_widgets/error_box.dart';
import '../widgets/forms_widgets/form_submit_button.dart';
import '../widgets/forms_widgets/link_form.dart';
import '../widgets/forms_widgets/text_block_form.dart';
import '../widgets/theme_widgets/exit_dialog_widget.dart';

class LoginScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> with WidgetsBindingObserver, WindowListener{
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  UserController userController = ServiceLocator.userController;
  AppConfig appConfig = ServiceLocator.appConfig;
  AuthState authState = ServiceLocator.authState;
  TasksLoadedState tasksLoadedState = ServiceLocator.taskLoadedState;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    windowManager.setPreventClose(true);
    windowManager.addListener(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  void onWindowClose() async {
    bool isConfirmed = await _showExitConfirmationDialog();
    if (isConfirmed) {
      windowManager.destroy();
    }
  }

  @override
  Widget build(BuildContext context) {
    double paddingValue = 20.0;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
            AppLocalizations.of(context)!.loginText,
            style: appConfig.theme.loginFormTitle,
        ),
        backgroundColor: appConfig.theme.backgroundLoginColor,
      ),
      backgroundColor: appConfig.theme.backgroundLoginColor,
      body: Padding(
        padding: EdgeInsets.all(paddingValue),
        child: Center(
          child: Consumer<AuthState>(
            builder: (BuildContext context, AuthState value, Widget? child) {
              if (authState.apiError) {
                Future.delayed(Duration.zero, () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return ApiErrorModal();
                    },
                  );
                });
              }
              return _isLoading
                  ? CircularProgressIndicator(color : appConfig.theme.iconColor)
                  : _loginForm(context, paddingValue);
            },
          ),
        ),
      ),
    );
  }

  Widget _loginForm(BuildContext context, double paddingValue) {
    return Column(
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
                        setState(() {
                          _isLoading = true;
                        });
                        await submitLogin(context);
                        setState(() {
                          _isLoading = false;
                        });
                      },
                      textButton: AppLocalizations.of(context)!.loginText),
                ),
                Padding(
                  padding: EdgeInsets.all(paddingValue),
                  child: LinkForm(
                    textNotLink : AppLocalizations.of(context)!.notAccount,
                    textLink:  AppLocalizations.of(context)!.registerUserLink,
                    onTap: () {
                      authState.setErrorMessage(null);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterScreen()),
                      );
                    },
                  ),
                )
              ],
            );
  }

  Future<void> submitLogin(BuildContext context) async {

    if (usernameController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      var res = await userController.loginUser(usernameController.text, passwordController.text);
      if (res['error'] != null) {
        incorrectLogin(res, context);
      } else {
        correctLogin(res, context);
      }
    } else {
      authState.setErrorMessage(AppLocalizations.of(context)!.emptyFields);
    }
  }

  void incorrectLogin(Map<String, dynamic> res, BuildContext context ) {
    var errorCode = res['error'];
    var errorMessage = Utils.getFormsErrorMessage(
        errorCode.toString(),
        context
    );
    authState.setErrorMessage(errorMessage);
  }

  void correctLogin(Map<String, dynamic> res, BuildContext context) async {
    authState.setLogged(true);
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
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }

  Future<bool> _showExitConfirmationDialog() async {
    return await showDialog(
      context: context,
      builder: (context) {
        return ExitDialog();
      },
    ) ?? false;
  }
}









