import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taskmate_app/config/app_config.dart';
import 'package:taskmate_app/services/service_locator.dart';

class StandardDialog extends StatelessWidget {
  final String title;
  final Widget content;

  StandardDialog({
    Key? key,
    required this.title,
    required this.content,
  }) : super(key: key);

  AppConfig appConfig = ServiceLocator.appConfig;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: appConfig.theme.modalBackgroundColor,
      title: Text(
        title,
        style: appConfig.theme.modalTitle,
      ),
      content: SingleChildScrollView(
        child: content,
      ),
    );
  }
}

class DialogTextTile extends StatelessWidget {
  final String text;

  DialogTextTile({
    Key? key,
    required this.text,
  }) : super(key: key);

  AppConfig appConfig = ServiceLocator.appConfig;

  @override
  Widget build(BuildContext context) {
    return Text(
        text,
        style: appConfig.theme.modalText,
    );
  }
}


