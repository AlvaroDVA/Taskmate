

import 'package:flutter/material.dart';
import 'package:taskmate_app/themes/light_theme.dart';

abstract class CustomTheme {

  late Color primaryColor;
  late Color secondaryColor;
  late Color lightColor;
  late Color lightColor2;
  late Color auxColor;
  late Color errorColor;
  late Color darkAuxColor;

  late TextStyle title;
  late TextStyle subtitle;
  late TextStyle text;
  late TextStyle diamongSelectedText;
  late TextStyle diamongNotSelectedText;

  factory CustomTheme.fromProperties(String theme) {
    if (theme == "Light") {
      return LightTheme();
    }

    return LightTheme();
  }
}