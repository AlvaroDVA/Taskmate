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
  Color greyColor = const Color(0xff3f3f3f);
  @override
  Color iconColor = const Color(0xffFFFFFF);
  @override
  Color shadowColor = const Color(0xff68615a);
  @override
  Color sublistColor = const Color(0xff68615a);
  @override
  Color modalBackgroundColor = const Color(0xffFFFFFF);
  @override
  Color backgroundLoginColor = const Color(0xffFFFFFF);
  @override
  Color formBlockColor = const Color(0xffffa500);

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

  @override
  late ButtonStyle modalButtonText;

  @override
  late TextStyle modalText;

  @override
  late TextStyle modalTitle;

  @override
  Color formTextLink = Color(0xffffa500);

  @override
  Color formTextNoLink=  const Color(0xff000000);

  @override
  late ButtonStyle loginButtonStyle;

  @override
  late TextStyle loginFormTitle;
  @override
  late ButtonStyle deleteUserButtonStyle;

  LightTheme() {
    title = TextStyle(
      color: auxColor,
      fontFamily: "Space Mono",
      fontSize: 16,
    );
    subtitle = TextStyle(
      color: auxColor,
      fontFamily: "Space Mono",
      fontSize: 14,
    );
    text = TextStyle(
      color: auxColor,
      fontFamily: "Space Mono",
      fontSize: 12,
    );
    diamongNotSelectedText = TextStyle(
      color: auxColor,
      fontFamily: "Space Mono",
      fontSize: 12,
    );
    diamongSelectedText = TextStyle(
      color: lightColor,
      fontFamily: "Space Mono",
      fontSize: 12,
    );
    modalButtonText = ButtonStyle(
      textStyle: MaterialStateProperty.all<TextStyle>(
        TextStyle(
          fontFamily: "Space Mono",
          fontSize: 16,
        ),
      ),
      foregroundColor: MaterialStateProperty.all<Color>(primaryColor),
    );
    modalText = TextStyle(
      fontFamily: "Space Mono",
      fontSize: 14,
    );
    modalTitle = TextStyle(
      fontFamily: "Space Mono",
      fontSize: 20,
      fontWeight: FontWeight.bold,
    );
    loginButtonStyle = ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(Color(0xffffa500)),
      textStyle: MaterialStateProperty.all<TextStyle>(
        TextStyle(
          fontFamily: "Space Mono",
          fontSize: 16,
        ),
      ),
      foregroundColor: MaterialStateProperty.all<Color>(
          const Color(0xffFFFFFF)),
    );
    loginFormTitle = TextStyle(
      color: Color(0xffffa500),
      fontFamily: "Space Mono",
      fontSize: 16,
    );
    deleteUserButtonStyle = ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(Color(0xffff0000)),
      textStyle: MaterialStateProperty.all<TextStyle>(
        TextStyle(
          fontFamily: "Space Mono",
          fontSize: 16,
        ),
      ),
      foregroundColor: MaterialStateProperty.all<Color>(Color(0xffffffff)),
    );
  }

  String get name => "light";


}
