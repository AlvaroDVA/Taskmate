import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:taskmate_app/controllers/day_controller.dart';
import 'package:taskmate_app/models/day.dart';
import 'package:taskmate_app/services/service_locator.dart';
import 'package:taskmate_app/states/tasks_loaded_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../models/task.dart';
import '../../states/auth_state.dart';
import 'login_screen.dart';

class DayTaskScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _DayTaskScreenTask();

}

class _DayTaskScreenTask extends State<DayTaskScreen> {
  final DayController dayController = ServiceLocator.dayController;
  final AuthState authState = ServiceLocator.authState;
  List<Task> todayTasks = [];
  late TasksLoadedState tasksLoadedState;
  bool firstLoad = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadTasks();
    });
  }

  void loadTasks() async{
    if (authState.isLogged) {
      var day = await dayController.loadDayTasks(authState.currentUser!, tasksLoadedState.currentDay.date);
      todayTasks = day.todayTasks;
      if (!day.loaded) {
        tasksLoadedState.setErrorMessage(AppLocalizations.of(context)!.tasksNotLoadedError);
      } else {
        tasksLoadedState.setErrorMessage(null);
      }
    }
    setState(() {
      todayTasks = tasksLoadedState.currentDay.todayTasks;
    });
  }

  @override
  Widget build(BuildContext context) {

    const double padding = 20.0;

    if (firstLoad) {
      tasksLoadedState = Provider.of<TasksLoadedState>(context);
      firstLoad = false;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Day Task Screen'),
      ),
      body: Center(
        child: Consumer<TasksLoadedState>(
          builder: (context, tasksLoadedState, child) {
            if (tasksLoadedState.currentDay.loaded) {
              return SingleChildScrollView(
                child: Column(
                  children: tasksLoadedState.currentDay.todayTasks.map((task) {
                    return  Padding(
                      padding: const EdgeInsets.all(padding),
                      child: Container(
                        color: Color(int.parse('0xff${task.hexColor.hex}')),
                          child: SizedBox(
                              child: Text(task.title.toString()))
                      ),
                    );
                  }).toList(),
                ),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Provider.of<AuthState>(context, listen: false).logoutUser();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
