import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taskmate_app/config/app_config.dart';
import 'package:taskmate_app/services/service_locator.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../states/auth_state.dart';

class ApiErrorModal extends StatelessWidget {
  ApiErrorModal({
    super.key,
  });

  final AuthState authState = ServiceLocator.authState;
  final AppConfig appConfig = ServiceLocator.appConfig;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: appConfig.theme.modalBackgroundColor,
      title: Text(
          AppLocalizations.of(context)!.errorApiModalTitle,
        style: appConfig.theme.title,
      ),
      content: Text(
          AppLocalizations.of(context)!.errorApiModalText,
          style: appConfig.theme.text,
      ),
      actions: <Widget>[
        TextButton(
          child: Text(AppLocalizations.of(context)!.okButton),
          style: appConfig.theme.modalButtonText,
          onPressed: () {
            Navigator.of(context).pop();
            authState.setApiError(false);
          },
        ),
      ],
    );
  }
}