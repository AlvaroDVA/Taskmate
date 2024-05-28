import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskmate_app/services/service_locator.dart';
import 'package:taskmate_app/states/auth_state.dart';
import 'package:taskmate_app/ui/pages/day_task_screen.dart';
import 'package:window_manager/window_manager.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../states/screens_state.dart';
import '../widgets/main_menu.dart';
import '../widgets/theme_widgets/exit_dialog_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> with WidgetsBindingObserver, WindowListener{

  ScreenState screenState = ServiceLocator.screenState;
  AuthState authState = ServiceLocator.authState;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    windowManager.setPreventClose(true);
    windowManager.addListener(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  void onWindowClose() async {
    bool isConfirmed = await _showExitConfirmationDialog();
    if (isConfirmed) {
      windowManager.destroy();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context1, constraints) {
          if (constraints.maxWidth > 650) {
            return Row(
              children: [
                Expanded(
                  flex: 1,
                  child: MainMenu(),
                ),
                Expanded(
                  flex: 3,
                  child: Consumer<ScreenState>(
                      builder: (BuildContext context, ScreenState screenState, Widget? child) {
                        return screenState.actualScreen;
                      }
                  ),
                ),
              ],
            );
          } else {
            return Consumer<ScreenState>(
                builder: (BuildContext context, ScreenState screenState, Widget? child) {
                  return screenState.actualScreen;
              }
            );
          }
        },
      ),
    );
  }


  Future<bool> _showExitConfirmationDialog() async {
    return await showDialog(
      context: context,
      builder: (context) {
        return ExitDialog();
      },
    ) ?? false;
  }
}

