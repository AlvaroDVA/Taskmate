import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:taskmate_app/config/app_config.dart';
import 'package:taskmate_app/controllers/day_controller.dart';
import 'package:taskmate_app/controllers/notebook_controller.dart';
import 'package:taskmate_app/controllers/user_controller.dart';
import 'package:taskmate_app/rest/notebook_api_rest.dart';
import 'package:taskmate_app/rest/user_api_rest.dart';
import 'package:taskmate_app/services/notebook_service.dart';
import 'package:taskmate_app/services/notification_service.dart';
import 'package:taskmate_app/services/service_locator.dart';
import 'package:taskmate_app/services/user_service.dart';
import 'package:taskmate_app/states/auth_state.dart';
import 'package:taskmate_app/states/notebook_state.dart';
import 'package:taskmate_app/states/screens_state.dart';
import 'package:taskmate_app/states/tasks_loaded_state.dart';
import 'package:taskmate_app/ui/pages/day_task_screen.dart';
import 'package:taskmate_app/ui/pages/home_page.dart';
import 'package:taskmate_app/ui/pages/login_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:timezone/data/latest.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  initializeTimeZones();
  await NotificationService.init();

  if (Platform.isWindows) {
    await windowManager.ensureInitialized();

    WindowOptions windowOptions = WindowOptions(
      size: Size(1000, 700),
      center: true,
      skipTaskbar: false,
      title: 'TaskMate App',
      titleBarStyle: TitleBarStyle.normal,
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  } else if (Platform.isAndroid) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }
  ServiceLocator.appConfig.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppConfig>(
          create: (_) => ServiceLocator.appConfig,
        ),
        ChangeNotifierProvider<NotebookState>(
          create: (_) => ServiceLocator.notebookState,
        ),
        Provider<UserController>(
          create: (_) => ServiceLocator.userController,
        ),
        Provider<UserService>(
          create: (_) => ServiceLocator.userService,
        ),
        Provider<NotebookService>(
          create: (_) => ServiceLocator.notebookService,
        ),
        Provider<UserApiRest>(
          create: (_) => ServiceLocator.userApiRest,
        ),
        Provider<NotebookApiRest>(
          create : (_) => ServiceLocator.notebookApiRest
        ),
        Provider<DayController>(
          create: (_) => ServiceLocator.dayController,
        ),
        Provider<NotebookController>(
          create: (_) => ServiceLocator.notebookController,
        ),
        ChangeNotifierProvider<AuthState>(
          create: (_) => ServiceLocator.authState,
        ),
        ChangeNotifierProvider<TasksLoadedState>(
          create: (_) => ServiceLocator.taskLoadedState,
        ),
        ChangeNotifierProvider<ScreenState>(
          create: (_) => ServiceLocator.screenState,
        )
      ],
      child: Consumer<AppConfig>(
        builder: (context, appConfig, child) {
          return Consumer<AuthState>(
            builder: (context1, authState, child) {
              return MaterialApp(
                checkerboardOffscreenLayers: false,
                debugShowCheckedModeBanner: false,
                title: 'TaskMate App',
                locale: appConfig.locale,
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: const [
                  Locale('en'),
                  Locale('es'),
                ],
                theme: ThemeData(
                  colorScheme: ColorScheme.fromSeed(seedColor: appConfig.theme.primaryColor),
                  useMaterial3: true,
                ),
                home: FutureBuilder(
                  future: authState.checkIsLogged(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Scaffold(
                        body: Center(child: CircularProgressIndicator()),
                      );
                    } else {
                      return authState.isLogged ? const HomePage() : LoginScreen();
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }


}


