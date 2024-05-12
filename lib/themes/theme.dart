import 'dart:ui';

import 'package:taskmate_app/themes/light_theme.dart';

abstract class CustomTheme {

  late Color primaryColor;
  late Color secondaryColor;
  late Color lightColor;
  late Color lightColor2;
  late Color auxColor;


  factory CustomTheme.fromProperties(String theme) {
    if (theme == "Light") {
      return LightTheme();
    }

    return LightTheme();
  }
}