import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskmate_app/ui/widgets/theme_widgets/day_changer_icon_widget.dart';

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
              DayChangerIcon(
                icon: Icons.arrow_back,
                onPressed: () {
                  taskLoadedState.saveCurrentTask();
                  taskLoadedState.setCurrentDay(
                      taskLoadedState.currentDay.date.subtract(Duration(days: 1))
                  );
                },
              ),
              Spacer(),
              Consumer <TasksLoadedState>(
                builder: (BuildContext context, TasksLoadedState tasksLoadedState, Widget? child){
                  return Text(
                    tasksLoadedState.currentDay.getStringDay(context),
                    style: appConfig.theme.title,
                  );
                }
              ),
              Spacer(),
              DayChangerIcon(
                icon: Icons.arrow_forward,
                onPressed: () {
                  taskLoadedState.saveCurrentTask();
                  taskLoadedState.setCurrentDay(taskLoadedState.currentDay.date.add(
                      Duration(days: 1)
                  ));
                },
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: appConfig.theme.lightColor2,
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
                      child:
                      DayChangerIcon(
                        icon: Icons.arrow_forward_ios_outlined,
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
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

