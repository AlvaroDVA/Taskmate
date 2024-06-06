import 'package:flutter/material.dart';
import 'package:taskmate_app/themes/theme.dart';

class DarkTheme implements CustomTheme {
  @override
  Color primaryColor = const Color(0xff121212);
  @override
  Color secondaryColor = const Color(0xff282828);
  @override
  Color lightColor = const Color(0xffffa500);
  @override
  Color lightColor2 = const Color(0xffFFE380);
  @override
  Color auxColor = const Color(0xffFFFFFF);
  @override
  Color darkAuxColor = const Color(0xff000000);
  @override
  Color greyColor = const Color(0xff3f3f3f);
  @override
  Color errorColor = const Color(0xffda0c0c);
  @override
  Color modalBackgroundColor = const Color(0xff3f3f3f);

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
  Color iconColor = const Color(0xffB38B00);

  @override
  Color shadowColor = const Color(0xff282828);

  @override
  Color sublistColor = const Color(0xff121212);

  @override
  Color backgroundLoginColor = const Color(0xff282828);

  @override
  Color formBlockColor = const Color(0xffffa500);

  @override
  Color formTextLink = const Color(0xffffa500);

  @override
  Color formTextNoLink = const Color(0xffFFFFFF);

  @override
  late ButtonStyle modalButtonText;

  @override
  late TextStyle modalText;

  @override
  late TextStyle modalTitle;

  @override
  late ButtonStyle loginButtonStyle;

  @override
  late TextStyle loginFormTitle;

  @override
  late ButtonStyle deleteUserButtonStyle;



  DarkTheme() {
    title = TextStyle(
      color: auxColor,
      fontFamily: "Space Mono",
      fontSize: 16,
      fontWeight: FontWeight.bold,
    );

    subtitle = TextStyle(
      color: auxColor.withOpacity(0.8),
      fontFamily: "Space Mono",
      fontSize: 14,
    );

    text = TextStyle(
      color: auxColor,
      fontFamily: "Space Mono",
      fontSize: 14,
    );

    diamongNotSelectedText = TextStyle(
      color: secondaryColor,
      fontFamily: "Space Mono",
      fontSize: 14,
    );

    diamongSelectedText = TextStyle(
      color: auxColor,
      fontFamily: "Space Mono",
      fontSize: 14,
    );
    modalButtonText = ButtonStyle(
      textStyle: MaterialStateProperty.all<TextStyle>(
        TextStyle(
          fontFamily: "Space Mono",
          fontSize: 16,
        ),
      ),
      foregroundColor: MaterialStateProperty.all<Color>(const Color(0xffffa500)),
    );
    modalText = TextStyle(
      color: const Color(0xffFFFFFF) ,
      fontFamily: "Space Mono",
      fontSize: 14,
    );
    modalTitle = TextStyle(
      color: const Color(0xffFFFFFF) ,
      fontFamily: "Space Mono",
      fontSize: 20,
      fontWeight: FontWeight.bold,
    );
    loginButtonStyle = ButtonStyle(
      textStyle: MaterialStateProperty.all<TextStyle>(
        TextStyle(
          fontFamily: "Space Mono",
          fontSize: 16,
        ),
      ),
      foregroundColor: MaterialStateProperty.all<Color>(Color(0xffffa500)),
    );
    loginFormTitle = TextStyle(
      color: Color(0xffFFFFFF),
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

  String get name => "dark";

  @override
  BoxDecoration todayDecoration = BoxDecoration(
    color: const Color(0xffbfe4e2),
    shape: BoxShape.rectangle,
    borderRadius: BorderRadius.circular(8.0),
  );

  @override
  BoxDecoration defaultDecoration = BoxDecoration(
    color: const Color(0xfff4a127),
    shape: BoxShape.rectangle,
    borderRadius: BorderRadius.circular(8.0),
    border: Border.all(color: Colors.grey),
  );

  @override
  BoxDecoration weekendDecoration = BoxDecoration(
    shape: BoxShape.rectangle,
    borderRadius: BorderRadius.circular(8.0),
    border: Border.all(color: Colors.grey),
    color: const Color(0xff282828),
  );

  @override
  BoxDecoration outsideDecoration = BoxDecoration(
    shape: BoxShape.rectangle,
    borderRadius: BorderRadius.circular(8.0),
    border: Border.all(color: Colors.grey),
      color : const Color(0xffe5f3f6)
  );

  @override
  BoxDecoration markedDecoration = BoxDecoration(
    color: Colors.white,
    shape: BoxShape.circle,
  );

  @override
  BoxDecoration selectedDecoration = BoxDecoration(
    color: Color(0xfffd7f06),
    shape: BoxShape.rectangle,
    borderRadius: BorderRadius.circular(8.0),
  );

  @override
  TextStyle defaultTextStyle = TextStyle(color: Colors.white);

  @override
  TextStyle holidayTextStyle = TextStyle(color: Colors.blue);

  @override
  TextStyle outsideTextStyle = TextStyle(color : Colors.black);

  @override
  TextStyle selectedTextStyle = TextStyle(color: Colors.white70);

  @override
  TextStyle todayTextStyle = TextStyle(color: Colors.black);

  @override
  TextStyle weekendTextStyle = TextStyle(color: Colors.white);

  @override
  TextStyle dayWeekTitle = TextStyle(
      color: Colors.white,
      fontFamily: "Space Mono",
      fontSize: 16,
      height: 1.2
  );

  @override
  Color notebookBackgroundColor = const Color(0xff121212);
}