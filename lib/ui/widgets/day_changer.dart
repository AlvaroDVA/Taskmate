import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/app_config.dart';
import '../../services/service_locator.dart';
import '../../states/tasks_loaded_state.dart';

class DayChanger extends StatelessWidget implements PreferredSizeWidget {
  final AppConfig appConfig = ServiceLocator.appConfig;
  TasksLoadedState taskLoadedState = ServiceLocator.taskLoadedState;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              color: appConfig.theme.secondaryColor
          ),
          child: Row(
            children: [
              IconButton(
                  onPressed: () {
                    taskLoadedState.saveCurrentTask();
                    taskLoadedState.setCurrentDay(taskLoadedState.currentDay.date.subtract(
                        Duration(days: 1)
                    ));
                  },
                  icon: Icon(Icons.arrow_back)
              ),
              Spacer(),
              Consumer <TasksLoadedState>(
                builder: (BuildContext context, TasksLoadedState tasksLoadedState, Widget? child){
                  return Text(tasksLoadedState.currentDay.getStringDay(context));
                }
              ),
              Spacer(),
              IconButton(
                  onPressed: () {
                    taskLoadedState.saveCurrentTask();
                    taskLoadedState.setCurrentDay(taskLoadedState.currentDay.date.add(
                        Duration(days: 1)
                    ));
                  },
                  icon: Icon(Icons.arrow_forward)
              )
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: appConfig.theme.lightColor,
          ),
          child: Row(
            children: [
              SizedBox(
                width: 40,
                height: 40,
                child: Builder(
                  builder: (context) {
                    final screenWidth = MediaQuery.of(context).size.width;
                    return Visibility(
                      visible: screenWidth <= 650,
                      child: IconButton(
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                        iconSize: 12,
                        icon: Icon(Icons.arrow_back_ios_new_rounded),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight * 1.45);

}