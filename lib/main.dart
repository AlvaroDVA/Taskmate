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
import 'package:taskmate_app/states/screens_state.dart';
import 'package:taskmate_app/states/tasks_loaded_state.dart';
import 'package:taskmate_app/ui/pages/day_task_screen.dart';
import 'package:taskmate_app/ui/pages/home_page.dart';
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
                title: 'Flutter Demo',
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
                      // Mientras se está verificando el estado de inicio de sesión, muestra un indicador de carga
                      return Scaffold(
                        body: Center(child: CircularProgressIndicator()),
                      );
                    } else {
                      // Cuando la verificación esté completa, muestra la pantalla correspondiente
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


