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
import 'package:taskmate_app/ui/widgets/theme_widgets/menu_tile.dart';

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
            MenuTile(
              icon: Icons.check_box_rounded,
              text: AppLocalizations.of(context)!.dayPageTitle,
              event: () {
                taskLoadedState.saveCurrentTask();
                screenState.setTaskScreen();
              },
            ),
            MenuTile(icon: Icons.calendar_month_rounded,
                text: AppLocalizations.of(context)!.calendarPageTitle,
                event: () {
                  screenState.setCalendarScreen();
                }
            ),
            MenuTile(icon: Icons.note_alt_outlined,
                text: AppLocalizations.of(context)!.notebookScreenTitle,
                event: () {
                  screenState.setNotebookScreen();
                }
            ),
            Expanded(
              child: Container(),
            ),
            MenuTile(
              icon: Icons.settings,
              text: AppLocalizations.of(context)!.settingsPageTitle,
              event: () {
                taskLoadedState.saveCurrentTask();
                screenState.setSettingsScreen();
              },
            ),
            MenuTile(
              icon: Icons.logout,
              text: AppLocalizations.of(context)!.closeSessionText,
              event: () async {
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


