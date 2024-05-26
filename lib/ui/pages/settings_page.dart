import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taskmate_app/config/app_config.dart';
import 'package:taskmate_app/services/service_locator.dart';
import 'package:taskmate_app/states/auth_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../enums/lenguages.dart';

class SettingsScreeen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SettingScreenState();




}

class SettingScreenState extends State<SettingsScreeen> {
  AuthState authState = ServiceLocator.authState;
  AppConfig appConfig = ServiceLocator.appConfig;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settingsPageTitle),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Avatar e información del usuario
          Container(
            color: Colors.grey[200],
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundImage: FileImage(authState.currentUser!.avatar),
                  radius: 50,
                ),
                SizedBox(height: 10),
                Text(
                  authState.currentUser!.username,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(authState.currentUser!.email),
              ],
            ),
          ),
          // Opciones de configuración
          Expanded(
            child: Builder(
              builder: (BuildContext context) {
                return ListView(
                  children: [
                    Card(
                      child: ListTile(
                        leading: Icon(Icons.palette),
                        title: Text(AppLocalizations.of(context)!.changeThemeText),
                        onTap: () {
                          // Lógica para cambiar el tema
                        },
                      ),
                    ),
                    Card(
                      child: ListTile(
                        leading: Icon(Icons.language),
                        title: Text(AppLocalizations.of(context)!.changeLanguageText),
                        onTap: () {
                          setState(() {
                            _showLanguageModal(context);
                          });
                        },
                      ),
                    ),
                    Card(
                      child: ListTile(
                        leading: Icon(Icons.delete),
                        title: Text(AppLocalizations.of(context)!.deleteUserText),
                        onTap: () {
                          // Lógica para eliminar el usuario
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),


        ],
      ),
    );
  }

  void _showLanguageModal(BuildContext context) {
    setState(() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Cambiar idioma'),
            content: SingleChildScrollView(
              child: Column(
                children: Language.values.map((language) {
                  return ListTile(
                    title: Text(_getLanguageName(language, context)),
                    onTap: () {
                      appConfig.changeLanguage(language);
                      Navigator.pop(context); // Cierra el diálogo
                    },
                  );
                }).toList(),
              ),
            ),
          );
        },
      );
    });
  }

  String _getLanguageName(Language language, BuildContext context) {
    switch (language) {
      case Language.english:
        return AppLocalizations.of(context)!.englishText;
      case Language.spanish:
        return AppLocalizations.of(context)!.spanishText;
    }
  }
}
