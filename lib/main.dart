import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:taskmate_app/config/app_config.dart';
import 'package:taskmate_app/controllers/day_controller.dart';
import 'package:taskmate_app/controllers/user_controller.dart';
import 'package:taskmate_app/rest/user_api_rest.dart';
import 'package:taskmate_app/services/service_locator.dart';
import 'package:taskmate_app/services/user_service.dart';
import 'package:taskmate_app/states/auth_state.dart';
import 'package:taskmate_app/states/tasks_loaded_state.dart';
import 'package:taskmate_app/ui/pages/day_task_screen.dart';
import 'package:taskmate_app/ui/pages/login_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  // Initialize window manager.
  await windowManager.ensureInitialized();

  // Set window options.
  WindowOptions windowOptions = WindowOptions(
    size: Size(1000, 700),
    center: true,
    skipTaskbar: false,
    title: 'Flutter Window Manager',
    titleBarStyle: TitleBarStyle.normal,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(
    ChangeNotifierProvider(
    create: (_) => AuthState(),
    child: MyApp(),

  ),);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    AuthState authState = Provider.of<AuthState>(context);
    AppConfig appConfig = ServiceLocator.appConfig;
    ServiceLocator.setAuthState(authState);
    return MultiProvider(
        providers: [
           Provider<AppConfig>(
             create: (_) => ServiceLocator.appConfig,
           ),
          Provider<UserController>(
            create: (_) => ServiceLocator.userController,
          ),
          Provider<UserService>(
              create: (_) => ServiceLocator.userService,
          ),
          Provider<UserApiRest>(
            create: (_) => ServiceLocator.userApiRest,
          ),
          Provider<DayController>(
            create: (_) => ServiceLocator.dayController,
          ),
          ChangeNotifierProvider<TasksLoadedState>(
            create: (_) => TasksLoadedState(),
          )
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
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
          home: authState.isLogged ? DayTaskScreen() : LoginScreen(),
        ),
    );
  }
}

