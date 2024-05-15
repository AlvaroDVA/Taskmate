import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:properties/properties.dart';
import 'package:taskmate_app/themes/theme.dart';


class AppConfig {

   String rutaArchivo = '${Directory.current.path}\\assets\\config.properties';
   late Properties properties;

   late CustomTheme theme;
   late String language;

   late String actualUser;
   late String urlApi;

   late String localDataUrl;


  AppConfig() {
    loadProperties();
  }

  void loadProperties() async {
    properties = Properties.fromFile(rutaArchivo);

    language = properties.get('language') ?? "English";
    theme = CustomTheme.fromProperties(properties.get('theme') ?? "Light");
    actualUser = properties.get('actualUser') ?? "None";
    urlApi = properties.get('urlApi') ?? "http://taskmate.ddns.net:15556";

    localDataUrl = _getLocalDataUrl();
  }

   String _getLocalDataUrl() {
     if (Platform.isAndroid) {
       return '/data/data/taskmate/files';
     } else if (Platform.isWindows) {
       return '${Platform.environment['LOCALAPPDATA']}\\taskmate\\';
     } else {
       throw UnsupportedError('Este sistema operativo no es compatible');
     }
   }

}