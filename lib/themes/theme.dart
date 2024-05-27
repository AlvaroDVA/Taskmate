

import 'package:flutter/material.dart';
import 'package:taskmate_app/themes/dark_theme.dart';
import 'package:taskmate_app/themes/light_theme.dart';

abstract class CustomTheme {

  late Color primaryColor;
  late Color secondaryColor;
  late Color lightColor;
  late Color lightColor2;
  late Color auxColor;
  late Color errorColor;
  late Color darkAuxColor;
  late Color greyColor;
  late Color iconColor;
  late Color shadowColor;
  late Color sublistColor;
  late Color modalBackgroundColor;
  late Color backgroundLoginColor;

  late TextStyle title;
  late TextStyle subtitle;
  late TextStyle text;
  late TextStyle diamongSelectedText;
  late TextStyle diamongNotSelectedText;
  late TextStyle modalTitle;
  late TextStyle modalText;
  late TextStyle loginFormTitle;
  late ButtonStyle modalButtonText;

  late Color formBlockColor;
  late Color formTextNoLink;
  late Color formTextLink;

  late ButtonStyle loginButtonStyle;

  late ButtonStyle deleteUserButtonStyle;


  factory CustomTheme.fromProperties(String theme) {
    if (theme == "light") {
      return LightTheme();
    }else if (theme == "dark") {
      return DarkTheme();
    }
    return LightTheme();
  }

  String get name => "null";
}