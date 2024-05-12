import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskmate_app/config/app_config.dart';
import 'package:taskmate_app/controllers/user_controller.dart';
import 'package:taskmate_app/rest/user_api_rest.dart';
import 'package:taskmate_app/services/service_locator.dart';
import 'package:taskmate_app/services/user_service.dart';
import 'package:taskmate_app/states/auth_state.dart';
import 'package:taskmate_app/ui/pages/login_screen.dart';

void main() {
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
    final authState = Provider.of<AuthState>(context);
    AppConfig appConfig = ServiceLocator.appConfig;
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
          )
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: appConfig.theme.primaryColor),
            useMaterial3: true,
          ),
          home: authState.isLogged ? MyHomePage(title: "TEST") : LoginScreen(),
        ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final UserController userController = ServiceLocator.userController;

  int _counter = 0;
  String state = "uihui";

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }





  @override
  Widget build(BuildContext context) {

    final authState = Provider.of<AuthState>(context);

    setState(() {
      state = authState.currentUser!.username;
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
             Text(
               state
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
