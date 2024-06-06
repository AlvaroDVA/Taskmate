import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taskmate_app/config/app_config.dart';
import 'package:taskmate_app/enums/app_theme.dart';
import 'package:taskmate_app/services/service_locator.dart';
import 'package:taskmate_app/states/auth_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taskmate_app/themes/dark_theme.dart';
import 'package:taskmate_app/themes/light_theme.dart';
import 'package:taskmate_app/themes/theme.dart';
import 'package:taskmate_app/ui/widgets/main_menu.dart';
import '../../enums/lenguages.dart';
import '../../services/notification_service.dart';
import '../widgets/theme_widgets/settings_card.dart';
import '../widgets/theme_widgets/simple_appbar.dart';
import '../widgets/theme_widgets/standard_dialog_widget.dart';
import 'login_screen.dart';

class SettingsScreeen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SettingScreenState();
}

class SettingScreenState extends State<SettingsScreeen> {
  AuthState authState = ServiceLocator.authState;
  AppConfig appConfig = ServiceLocator.appConfig;

  @override
  void initState() {
    super.initState();
    NotificationService.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainMenu(),
      backgroundColor: appConfig.theme.primaryColor,
      appBar: SimpleAppbar(text : AppLocalizations.of(context)!.settingsPageTitle),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: appConfig.theme.greyColor,
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    _openAvatarChangeDialog();
                  },
                  child: CircleAvatar(
                    backgroundImage: FileImage(authState.currentUser!.avatar),
                    radius: 50,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  authState.currentUser!.username,
                  style: appConfig.theme.text,
                ),
                Text(
                  authState.currentUser!.email,
                  style: appConfig.theme.text,
                ),
              ],
            ),
          ),
          // Opciones de configuración
          Expanded(
            child: Builder(
              builder: (BuildContext context) {
                return ListView(
                  children: [
                    SettingsCard(
                      leadingIcon: Icons.palette,
                      title: AppLocalizations.of(context)!.changeThemeText,
                      onTap: () {
                        setState(() {
                          _showThemeModal(context);
                        });
                      },
                    ),
                    SettingsCard(
                      leadingIcon: Icons.language,
                      title: AppLocalizations.of(context)!.changeLanguageText,
                      onTap: () {
                        setState(() {
                          _showLanguageModal(context);
                        });
                      },
                    ),
                    if (Platform.isAndroid)
                      SettingsCard(
                        leadingIcon: Icons.notifications,
                        title: AppLocalizations.of(context)!.notificationsText,
                        onTap: () {
                          _showNotificationsModal(context);
                        },
                      ),
                    SettingsCard(
                      leadingIcon: Icons.delete,
                      title: AppLocalizations.of(context)!.deleteUserText,
                      onTap: () {
                        setState(() {
                          _showDeleteUserModal(context);
                        });
                      },
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
          return StandardDialog(
            title: AppLocalizations.of(context)!.changeLanguageText,
            content: SingleChildScrollView(
              child: Column(
                children: Language.values.map((language) {
                  return ListTile(
                    title: DialogTextTile(
                        text: _getLanguageName(language, context)),
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

  void _showThemeModal(BuildContext context) {
    setState(() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return StandardDialog(
            title: AppLocalizations.of(context)!.changeThemeText,
            content: SingleChildScrollView(
              child: Column(
                children: AppTheme.values.map((theme) {
                  return ListTile(
                    title: DialogTextTile(text: _getThemeName(theme, context)),
                    onTap: () {
                      appConfig.changeTheme(toTheme(theme));
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

  CustomTheme toTheme(AppTheme theme) {
    switch (theme) {
      case AppTheme.light:
        return LightTheme();
      case AppTheme.dark:
        return DarkTheme();
    }
  }

  String _getThemeName(AppTheme theme, BuildContext context) {
    switch (theme) {
      case AppTheme.light:
        return AppLocalizations.of(context)!.lightThemeText;
      case AppTheme.dark:
        return AppLocalizations.of(context)!.darkThemeText;
    }
  }

  void _showDeleteUserModal(BuildContext context) {
    setState(() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return StandardDialog(
              title: AppLocalizations.of(context)!.deleteUserWarning,
              content: Row(
                children: [
                  Spacer(),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: Text(AppLocalizations.of(context)!.cancelButton),
                    style: appConfig.theme.modalButtonText,
                  ),
                  Spacer(),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                        authState.deleteUser();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()),
                        );
                      },
                      child: Text(
                        AppLocalizations.of(context)!.deleteButton,
                      ),
                      style: appConfig.theme.deleteUserButtonStyle
                  ),
                  Spacer(),
                ],
              )
          );
        },
      );
    });
  }

  Future<void> _openAvatarChangeDialog() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowCompression: true,
    );

    if (result != null) {
      setState(() async {
        await authState.changeAvatar(result.files.single.path);
      });
    }
  }

  void _showNotificationsModal(BuildContext context) {
    int selectedHour = TimeOfDay.now().hour;
    int selectedMinute = TimeOfDay.now().minute;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: appConfig.theme.modalBackgroundColor,
              title: Text(
                AppLocalizations.of(context)!.notificationModalText,
                style: appConfig.theme.title,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Text(
                            AppLocalizations.of(context)!.hourText,
                            style: appConfig.theme.title,
                          ),
                          DropdownButton<int>(
                            dropdownColor: appConfig.theme.modalBackgroundColor,
                            value: selectedHour,
                            onChanged: (value) {
                              setState(() {
                                selectedHour = value!;
                              });
                            },
                            items: List.generate(24, (index) {
                              return DropdownMenuItem<int>(
                                value: index,
                                child: Text(
                                  index.toString().padLeft(2, '0'),
                                  style: appConfig.theme.text,
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            AppLocalizations.of(context)!.minuteText,
                            style: appConfig.theme.title,
                          ),
                          DropdownButton<int>(
                            dropdownColor: appConfig.theme.modalBackgroundColor,
                            value: selectedMinute,
                            onChanged: (value) {
                              setState(() {
                                selectedMinute = value!;
                              });
                            },
                            items: List.generate(60, (index) {
                              return DropdownMenuItem<int>(
                                value: index,
                                child: Text(
                                  index.toString().padLeft(2, '0'),
                                  style: appConfig.theme.text,
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(AppLocalizations.of(context)!.cancelButton
                  ),
                    style: appConfig.theme.modalButtonText
                ),
                TextButton(
                  onPressed: () {
                    NotificationService.showScheduledNotification(context, selectedHour, selectedMinute);
                    Navigator.of(context).pop();
                  },
                  child: Text(AppLocalizations.of(context)!.okButton),
                    style: appConfig.theme.modalButtonText
                ),
              ],
            );
          },
        );
      },
    );
  }

}

