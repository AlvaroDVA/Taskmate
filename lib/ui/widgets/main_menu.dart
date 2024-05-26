import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskmate_app/config/app_config.dart';
import 'package:taskmate_app/services/service_locator.dart';
import 'package:taskmate_app/states/auth_state.dart';
import 'package:taskmate_app/states/screens_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taskmate_app/states/tasks_loaded_state.dart';
import 'package:taskmate_app/ui/pages/login_screen.dart';

class MainMenu extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MainMenuState();

}

class MainMenuState extends State<MainMenu> {
  ScreenState screenState = ServiceLocator.screenState;
  AppConfig appConfig = ServiceLocator.appConfig;
  AuthState authState = ServiceLocator.authState;
  TasksLoadedState taskLoadedState = ServiceLocator.taskLoadedState;

  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(
        color: appConfig.theme.secondaryColor,
      ),
      child: Drawer(
        backgroundColor: appConfig.theme.secondaryColor,
        child: Column(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.check_box_rounded),
              title: Text(AppLocalizations.of(context)!.dayPageTitle),
              onTap: () {
                taskLoadedState.saveCurrentTask();
                screenState.setTaskScreen();
              },
            ),
            Expanded(
              child: Container(),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text(AppLocalizations.of(context)!.settingsPageTitle),
              onTap: () {
                taskLoadedState.saveCurrentTask();
                screenState.setSettingsScreen();
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text(AppLocalizations.of(context)!.closeSessionText),
              onTap: () async {
                  await taskLoadedState.saveCurrentTask();
                  await authState.logoutUser();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );

              },
            ),
          ],
        ),
      ),
    );
  }
}