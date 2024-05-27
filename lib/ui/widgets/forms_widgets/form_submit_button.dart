import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taskmate_app/services/service_locator.dart';

import '../../../config/app_config.dart';

class FormSubmitButton extends StatelessWidget {

  final String textButton;
  final VoidCallback? onPressed;

  FormSubmitButton({
    super.key,
    required this.textButton,
    this.onPressed,
  });

  AppConfig appConfig = ServiceLocator.appConfig;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        child: Text(textButton),
      style: appConfig.theme.loginButtonStyle,
    );
  }

}