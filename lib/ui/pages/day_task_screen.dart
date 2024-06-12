import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskmate_app/config/app_config.dart';
import 'package:taskmate_app/controllers/day_controller.dart';
import 'package:taskmate_app/enums/color_task.dart';
import 'package:taskmate_app/services/service_locator.dart';
import 'package:taskmate_app/states/tasks_loaded_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taskmate_app/ui/widgets/theme_widgets/standard_dialog_widget.dart';
import '../widgets/main_menu.dart';
import 'package:taskmate_app/ui/widgets/task_widget.dart';
import 'package:window_manager/window_manager.dart';

import '../../models/task.dart';
import '../../states/auth_state.dart';
import '../widgets/day_changer.dart';

class DayTaskScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _DayTaskScreenState();

}

class _DayTaskScreenState extends State<DayTaskScreen> with WidgetsBindingObserver, WindowListener{
  final DayController dayController = ServiceLocator.dayController;
  final AuthState authState = ServiceLocator.authState;
  final TasksLoadedState tasksLoadedState = ServiceLocator.taskLoadedState;
  final AppConfig appConfig = ServiceLocator.appConfig;
  final ScrollController _scrollController = ScrollController();
  bool loaded = false;
  @override
  void initState() {
    super.initState();
    _initialice();
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
      tasksLoadedState.saveCurrentTask();
    }
  }

  @override
  void onWindowClose() async {
    dayController.saveDay(tasksLoadedState.currentDay, authState.currentUser);
  }

  Future<void> loadTasks() async {
    print(authState.isLogged);
    if (authState.isLogged) {
      tasksLoadedState.loadCurrentDay(DateTime.now());
      if (!tasksLoadedState.currentDay.loaded) {
        tasksLoadedState.setErrorMessage(
            AppLocalizations.of(context)!.tasksNotLoadedError);
      } else {
        tasksLoadedState.setErrorMessage(null);
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    final breakpoint = 650.0;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawerEnableOpenDragGesture: screenWidth < breakpoint,
      drawer: MainMenu(),
      appBar: DayChanger(),
      body: Container(
        color: appConfig.theme.primaryColor,
        child: Container(
          color: Colors.transparent,
          child: Padding(
            padding: EdgeInsets.only(bottom: 50),
            child: Consumer<TasksLoadedState>(
              builder: (BuildContext context, TasksLoadedState tasksLoadedState, Widget? child) {
                  if (tasksLoadedState.isLoaded) {
                  return NestedScrollView(
                      controller: _scrollController,
                      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                        return <Widget>[
                          SliverOverlapAbsorber(
                            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                          ),
                        ];
                      },
                  body: Center(
                      child : ListView.separated(
                        controller: _scrollController,
                          itemCount: tasksLoadedState.currentDay.todayTasks.length,
                          separatorBuilder: (_, index) => SizedBox(height: 10,),
                          itemBuilder: (_, index) {
                            return TaskWidget(
                                actualTask: tasksLoadedState.currentDay.todayTasks[index],
                                onDelete : () {
                                  setState(() {
                                    tasksLoadedState.currentDay.todayTasks.removeAt(index);
                                  });
                                },
                            );
                          }
                      )
                    )
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(
                      color: appConfig.theme.iconColor,
                    ),
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
        child: Icon(
          Icons.add,
          color: appConfig.theme.darkAuxColor,
        ),
        backgroundColor: appConfig.theme.lightColor2,
      ),
    );
  }

  void _showColorPickerDialog() async {
    ColorTask? selectedColor = await showDialog<ColorTask>(
      context: context,
      builder: (context) => StandardDialog(
        title: AppLocalizations.of(context)!.selectColorText,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ColorTask.values.map((color) {
            return ListTile(
              leading: CircleAvatar(backgroundColor: Color(int.parse('0xff${color.hex}'))),
              title: DialogTextTile(text : generarColorTraducido(color, context).split('.').last),
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
      case ColorTask.green:
        return AppLocalizations.of(context)!.greenColor;
      case ColorTask.orange:
        return AppLocalizations.of(context)!.orangeColor;
    }
  }

  onDelete(int index) {
    tasksLoadedState.currentDay.todayTasks.removeAt(index);
  }

  Future<void> _initialice() async {
    await authState.checkIsLogged();
    await tasksLoadedState.loadCurrentDay
      (tasksLoadedState.currentDay.date);
    WidgetsBinding.instance.addObserver(this);
    windowManager.setPreventClose(true);
    windowManager.addListener(this);
  }

}


