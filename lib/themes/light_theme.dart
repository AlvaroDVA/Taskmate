import 'package:flutter/material.dart';
import 'package:taskmate_app/themes/theme.dart';

class LightTheme implements CustomTheme {
  @override
  Color primaryColor = const Color(0xffFFA500);
  @override
  Color secondaryColor = const Color(0xffB38B00);
  @override
  Color lightColor = const Color(0xffFFF1BF);
  @override
  Color lightColor2 = const Color(0xffFFE380);
  @override
  Color auxColor = const Color(0xffFFFFFF);
  @override
  Color darkAuxColor = const Color(0xff000000);
  @override
  Color errorColor = const Color(0xffda0c0c);

  @override
  late TextStyle diamongNotSelectedText;

  @override
  late TextStyle diamongSelectedText;

  @override
  late TextStyle subtitle;

  @override
  late TextStyle text;

  @override
  late TextStyle title;

  LightTheme() {
    title = TextStyle(
      color: auxColor,
      fontFamily: "Space Mono",
      fontSize: 16
    );
  }
}