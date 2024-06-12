import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskmate_app/ui/pages/home_page.dart';
import 'package:taskmate_app/ui/pages/login_screen.dart';
import 'package:uuid/uuid.dart';
import 'package:window_manager/window_manager.dart';

import '../../config/app_config.dart';
import '../../controllers/user_controller.dart';
import '../../main.dart';
import '../../models/user.dart';
import '../../services/service_locator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../states/auth_state.dart';
import '../../utils/utils.dart';
import '../widgets/api_error_modal_widget.dart';
import '../widgets/forms_widgets/error_box.dart';
import '../widgets/forms_widgets/form_submit_button.dart';
import '../widgets/forms_widgets/link_form.dart';
import '../widgets/forms_widgets/text_block_form.dart';
import '../widgets/theme_widgets/exit_dialog_widget.dart';
import 'day_task_screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> with WidgetsBindingObserver, WindowListener{
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController repeatPasswordController = TextEditingController();
  final UserController userController = ServiceLocator.userController;
  final AppConfig appConfig = ServiceLocator.appConfig;
  final authState = ServiceLocator.authState;

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
            AppLocalizations.of(context)!.registerText,
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
                  : _registerForm(context, paddingValue);
            },
          ),
        ),
      ),
    );
  }

  Widget _registerForm(BuildContext context, double paddingValue) {
    return Column(
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
                onPressed: () async {
                  setState(() {
                    _isLoading = true;
                  });
                  try {
                    await registerForm(context, authState);
                  } catch (e) {
                    print("Error submitting register: $e");
                    authState.setApiError(true); // Establecer error de API en true
                  } finally {
                    setState(() {
                      _isLoading = false;
                    });
                  }await submitRegister(context);
                  setState(() {
                    _isLoading = false;
                  });
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
                  authState.setErrorMessage(null);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
              ),
            )
          ],
        );
  }

  Future<void> submitRegister(BuildContext context) async {

    String username = usernameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text;
    String repeatPassword = repeatPasswordController.text;

    if (username.isEmpty || email.isEmpty || password.isEmpty || repeatPassword.isEmpty) {
      authState.setErrorMessage(AppLocalizations.of(context)!.emptyFields);
      return;
    }

    if (!isUsernameValid(username)) {
      authState.setErrorMessage(AppLocalizations.of(context)!.invalidUsername);
      return;
    }

    if (!isEmailValid(email)) {
      authState.setErrorMessage(AppLocalizations.of(context)!.invalidEmailFormat);
      return;
    }

    if (password.length < 8) {
      authState.setErrorMessage(AppLocalizations.of(context)!.passwordTooShort);
      return;
    }

    if (password != repeatPassword) {
      authState.setErrorMessage(AppLocalizations.of(context)!.passwordsDoNotMatch);
      return;
    }

    await registerForm(context, authState);
  }

  bool isEmailValid(String email) {
    final RegExp emailRegex = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
      caseSensitive: false,
      multiLine: false,
    );
    return emailRegex.hasMatch(email);
  }

  bool isUsernameValid(String username) {
    final RegExp usernameRegex = RegExp(
      r'^[a-zA-Z0-9_]{5,20}$',
      caseSensitive: false,
      multiLine: false,
    );
    return usernameRegex.hasMatch(username);
  }

  bool isAnyFieldEmpty(String username, String email, String password, String repeatPassword) {
    return username.isEmpty || email.isEmpty || password.isEmpty || repeatPassword.isEmpty;
  }

  Future<void> registerForm(BuildContext context, AuthState authState) async {
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
        await correctLogin(authState, res, context);
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

  Future<void> correctLogin(AuthState authState, Map<String, dynamic> res, BuildContext context) async {
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