import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taskmate_app/services/service_locator.dart';

import '../../../config/app_config.dart';

class ExitDialog extends StatelessWidget {

  AppConfig appConfig = ServiceLocator.appConfig;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AlertDialog(
        backgroundColor: appConfig.theme.modalBackgroundColor,
        title: Text(
            AppLocalizations.of(context)!.exitConfirmText,
            style: appConfig.theme.modalTitle,
        ),
        content: Text(
            AppLocalizations.of(context)!.exitConfirmBody,
            style: appConfig.theme.modalText,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text(AppLocalizations.of(context)!.cancelButton),
            style: appConfig.theme.modalButtonText,
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Text(AppLocalizations.of(context)!.exitButton),
            style: appConfig.theme.modalButtonText,
          ),
        ],
      ),
    );
  }
}