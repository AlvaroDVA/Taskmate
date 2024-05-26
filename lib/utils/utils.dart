
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:io';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:path_provider/path_provider.dart';


class Utils {
  static String getFormsErrorMessage(String errorCode, BuildContext context) {
    return _checkFormsErrorCode(errorCode, context);
  }

  static String _checkFormsErrorCode(String errorCode, BuildContext context) {
    switch (errorCode) {
      case "1001" :
        return AppLocalizations.of(context)!.err1001;
      case "1002" :
        return AppLocalizations.of(context)!.err1002;
      case "1003" :
        return AppLocalizations.of(context)!.err1003;
      case "1004" :
        return AppLocalizations.of(context)!.err1004;
      case "1020" :
        return AppLocalizations.of(context)!.err1020;
      case "1021" :
        return AppLocalizations.of(context)!.err1021;
      case "1022" :
        return AppLocalizations.of(context)!.err1022;
      case "1023" :
        return AppLocalizations.of(context)!.err1023;
      case "1030" :
        return AppLocalizations.of(context)!.err1030;
      case "1050" :
        return AppLocalizations.of(context)!.err1050;
      case "1051" :
        return AppLocalizations.of(context)!.err1051;
      case "1052" :
        return AppLocalizations.of(context)!.err1052;
      case "1053" :
        return AppLocalizations.of(context)!.err1053;
      case "1060" :
        return AppLocalizations.of(context)!.err1060;
      case "1061" :
        return AppLocalizations.of(context)!.err1061;
      case "1062" :
        return AppLocalizations.of(context)!.err1062;
      case "1063" :
        return AppLocalizations.of(context)!.err1001;
      default :
        return AppLocalizations.of(context)!.unknownError;
    }
  }

  static Future<File> getBasicAvatar() async{
    final ByteData data = await rootBundle.load('assets/images/avatar.png');
    final List<int> bytes = data.buffer.asUint8List();

    final tempDir = await getTemporaryDirectory();
    final tempFile = File("${tempDir.path}/avatar.png");
    await tempFile.writeAsBytes(bytes);

    return tempFile;
  }

  static Future<File> fileFromBytes(String? string) async {
    List<int> avatarBytes = base64Decode(string!);

    Directory tempDir = await getTemporaryDirectory();

    File avatarFile = File('${tempDir.path}/avatar.png');

    await avatarFile.writeAsBytes(avatarBytes);

    return avatarFile;
  }

  static Future<bool> _showExitConfirmationDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.exitConfirmText),
          content: Text(AppLocalizations.of(context)!.exitConfirmBody),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(AppLocalizations.of(context)!.cancelButton),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text(AppLocalizations.of(context)!.exitButton),
            ),
          ],
        );
      },
    ) ?? false;
  }

}