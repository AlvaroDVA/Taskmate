import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskmate_app/services/service_locator.dart';

import '../../../config/app_config.dart';


class TextBlockForm extends StatelessWidget {
  TextBlockForm({
    super.key,
    required this.textEditingController,
    required this.text,
    required this.isHiddenText,
  });

  final AppConfig appConfig = ServiceLocator.appConfig;
  final TextEditingController textEditingController;
  final String text;
  final bool isHiddenText;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      child: TextField(
        controller: textEditingController,
        decoration: InputDecoration(
          labelText: text,
          labelStyle: TextStyle(
            color: appConfig.theme.formBlockColor,
            fontFamily: "Space Mono",
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: appConfig.theme.formBlockColor),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: appConfig.theme.formBlockColor),
          ),
        ),
        style: TextStyle(
          color: appConfig.theme.formBlockColor,
          fontFamily: "Space Mono",
        ),
        obscureText: isHiddenText,
      ),
    );
  }
}



