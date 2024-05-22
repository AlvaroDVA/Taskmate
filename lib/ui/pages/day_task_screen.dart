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
import 'package:window_manager/window_manager.dart';

import '../../models/task.dart';
import '../../states/auth_state.dart';
import 'login_screen.dart';

class DayTaskScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _DayTaskScreenState();

}

class _DayTaskScreenState extends State<DayTaskScreen> with WidgetsBindingObserver, WindowListener{
  final DayController dayController = ServiceLocator.dayController;
  final AuthState authState = ServiceLocator.authState;
  late TasksLoadedState tasksLoadedState;
  final AppConfig appConfig = ServiceLocator.appConfig;
  final ScrollController _scrollController = ScrollController();
  bool firstLoad = true;

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
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) {
      dayController.saveDay(tasksLoadedState.currentDay, authState.currentUser);
    }
  }

  @override
  void onWindowClose() async {
    bool isConfirmed = await _showExitConfirmationDialog();
    if (isConfirmed) {
      windowManager.destroy();
    }
  }

  Future<bool> _showExitConfirmationDialog() async {
    dayController.saveDay(tasksLoadedState.currentDay, authState.currentUser);
    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.exitConfirmText),
          content: Text(AppLocalizations.of(context)!.exitConfirmBody),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(AppLocalizations.of(context)!.cancelButton),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text(AppLocalizations.of(context)!.exitButton),
            ),
          ],
        );
      },
    ) ?? false;
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
        child: Container(
          color: Colors.transparent,
          child: Padding(
            padding: EdgeInsets.only(bottom: 50),
            child: Consumer<TasksLoadedState>(
              builder: (BuildContext context, TasksLoadedState tasksLoadedState, Widget? child) {
                if (tasksLoadedState.currentDay.loaded) {
                  return Center(
                      child : ListView.separated(
                        controller: _scrollController,
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
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _showColorPickerDialog();
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showColorPickerDialog() async {
    ColorTask? selectedColor = await showDialog<ColorTask>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.selectColorText),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ColorTask.values.map((color) {
            return ListTile(
              leading: CircleAvatar(backgroundColor: Color(int.parse('0xff${color.hex}'))),
              title: Text(generarColorTraducido(color, context).split('.').last),
              onTap: () => Navigator.of(context).pop(color),
            );
          }).toList(),
        ),
      ),
    );

    if (selectedColor != null) {
      setState(() {
        tasksLoadedState.currentDay.todayTasks.add(
          Task(
            idTask: tasksLoadedState.currentDay.todayTasks.length,
            title: "",
            isChecked: false,
            hexColor: selectedColor,
            elementList: [],
          ),
        );
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  String generarColorTraducido(ColorTask color, BuildContext context) {
    switch (color) {
      case ColorTask.blue:
        return AppLocalizations.of(context)!.blueColor;
      case ColorTask.red:
        return AppLocalizations.of(context)!.redColor;
      case ColorTask.yellow:
        return AppLocalizations.of(context)!.yellowColor;
      case ColorTask.white:
        return AppLocalizations.of(context)!.whiteColor;
      case ColorTask.orange:
        return AppLocalizations.of(context)!.orangeColor;
    }
  }

}
