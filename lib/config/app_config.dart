import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:properties/properties.dart';
import 'package:taskmate_app/enums/app_theme.dart';
import 'package:taskmate_app/enums/lenguages.dart';
import 'package:taskmate_app/themes/theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class AppConfig extends ChangeNotifier{

   late String rutaArchivo;
   late Properties properties;

   late CustomTheme theme;
   late Locale _locale;
   Locale get locale => _locale;
   late String language;

   late String urlApi;

   late String localDataUrl;


  AppConfig() {
    initialize();
  }

  Future<void> initialize() async {
    if (Platform.isWindows) {
      rutaArchivo = '${Directory.current.path}\\assets\\config.properties';
    } else if (Platform.isAndroid) {
      final directory = await getApplicationDocumentsDirectory();
      rutaArchivo = '${directory.path}/config.properties';
    }

    await loadProperties();
    print(locale.languageCode);
  }


   Future<void> loadProperties() async {
    File file = File(rutaArchivo);
    if (!file.existsSync()) {
      const defaultProperties = '''
        theme=light
        language=english
        urlApi = http://taskmate.ddns.net:15556
        ''';
      await file.writeAsString(defaultProperties);
    }



    properties = Properties.fromFile(rutaArchivo);


     language = properties.get('language') ?? "English";
     await _loadLocale(language);
     theme = CustomTheme.fromProperties(properties.get('theme') ?? "light");
     urlApi = properties.get('urlApi') ?? "http://taskmate.ddns.net:15556";

     localDataUrl = _getLocalDataUrl();

     notifyListeners();
   }

   Future<void> _loadLocale(String language) async {
     switch (language.toLowerCase()) {
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

   Future<void> changeTheme(CustomTheme theme) async {
     properties['theme'] = theme.name;
     this.theme = theme;
     await _loadLocale(language);
     await saveProperties();
     notifyListeners();
   }

   Future<void> saveProperties() async {
     properties.saveToFile(rutaArchivo);
   }

}