import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:properties/properties.dart';
import 'package:taskmate_app/themes/theme.dart';

class AppConfig {

  String rutaArchivo = '${Directory.current.path}/config.properties';
  late Properties properties;

  late CustomTheme theme;
  late String language;

  late String actualUser;

  AppConfig() {
    loadProperties();
  }

  void loadProperties() async {
    properties = Properties.fromFile(rutaArchivo);

    language = properties.get('language') ?? "English";
    theme = CustomTheme.fromProperties(properties.get('theme') ?? "Light");

    actualUser = properties.get('actualUser') ?? "None";

  }

}