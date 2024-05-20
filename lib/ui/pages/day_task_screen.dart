import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:taskmate_app/config/app_config.dart';
import 'package:taskmate_app/controllers/day_controller.dart';
import 'package:taskmate_app/enums/color_task.dart';
import 'package:taskmate_app/models/day.dart';
import 'package:taskmate_app/services/service_locator.dart';
import 'package:taskmate_app/states/tasks_loaded_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taskmate_app/ui/widgets/task_widget.dart';
import 'package:uuid/uuid.dart';

import '../../models/task.dart';
import '../../states/auth_state.dart';
import 'login_screen.dart';

class DayTaskScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _DayTaskScreenState();

}

class _DayTaskScreenState extends State<DayTaskScreen> {
  final DayController dayController = ServiceLocator.dayController;
  final AuthState authState = ServiceLocator.authState;
  late TasksLoadedState tasksLoadedState;
  final AppConfig appConfig = ServiceLocator.appConfig;
  bool firstLoad = true;

  @override
  void initState() {
    super.initState();
  }

  void loadTasks() async {
    if (authState.isLogged) {
      var day = await dayController.loadDayTasks(
          authState.currentUser!, tasksLoadedState.currentDay.date);
      if (!day.loaded) {
        tasksLoadedState.setErrorMessage(
            AppLocalizations.of(context)!.tasksNotLoadedError);
      } else {
        tasksLoadedState.setErrorMessage(null);
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if(firstLoad) {
      tasksLoadedState = Provider.of<TasksLoadedState>(context);
    }

    return Scaffold(
      // TODO Cambiador de dias
      appBar: AppBar(
        title: Center(child: Text('Day Task Screen')),
        backgroundColor: appConfig.theme.secondaryColor,
      ),
      body: Container(
        color: appConfig.theme.primaryColor,
        child: Consumer<TasksLoadedState>(
          builder: (BuildContext context, TasksLoadedState tasksLoadedState, Widget? child) {
            if (tasksLoadedState.currentDay.loaded) {
              return Center(
                  child : ListView.separated(
                      itemCount: tasksLoadedState.currentDay.todayTasks.length,
                      separatorBuilder: (_, index) => Spacer(),
                      itemBuilder: (_, index) {
                        return TaskWidget(actualTask: tasksLoadedState.currentDay.todayTasks[index]);
                      }
                  )
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        //TODO ADD NEW NOTE
        onPressed: () {
          setState(() {
            tasksLoadedState.currentDay.todayTasks.add(
              Task(idTask: 0, title: "", isChecked: false, hexColor: ColorTask.red, elementList: [])
            );
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }


}
