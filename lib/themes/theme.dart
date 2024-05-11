import 'dart:ui';

import 'package:taskmate_app/themes/light_theme.dart';

abstract class CustomTheme {


  factory CustomTheme.fromProperties(String theme) {
    if (theme == "Light") {
      return LightTheme();
    }

    return LightTheme();
  }
}