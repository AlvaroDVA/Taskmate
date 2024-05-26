import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:properties/properties.dart';
import 'package:taskmate_app/enums/lenguages.dart';
import 'package:taskmate_app/themes/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppConfig extends ChangeNotifier{

   String rutaArchivo = '${Directory.current.path}\\assets\\config.properties';
   late Properties properties;

   late CustomTheme theme;
   late Locale _locale;
   Locale get locale => _locale;
   late String language;

   late String urlApi;

   late String localDataUrl;


  AppConfig() {
    loadProperties();
  }

   Future<void> loadProperties() async {
     properties = Properties.fromFile(rutaArchivo);

     language = properties.get('language') ?? "English";
     theme = CustomTheme.fromProperties(properties.get('theme') ?? "Light");
     urlApi = properties.get('urlApi') ?? "http://taskmate.ddns.net:15556";

     await _loadLocale(language);

     localDataUrl = _getLocalDataUrl();
     notifyListeners();
   }

   Future<void> _loadLocale(String language) async {
     switch (language) {
       case "english":
         _locale = Locale('en');
         break;
       case "spanish":
         _locale = Locale('es');
         break;
       default:
         _locale = Locale('en'); // Establece un valor predeterminado
     }
    notifyListeners();
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

   Future<void> changeLanguage(Language newLanguage) async {
     properties['language'] = newLanguage.name;
     language = newLanguage.name;
     await _loadLocale(language);
     await saveProperties();
     notifyListeners();
   }

   Future<void> saveProperties() async {
     properties.saveToFile(rutaArchivo);
   }

}