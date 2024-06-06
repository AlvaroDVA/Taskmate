
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskmate_app/config/app_config.dart';
import 'package:taskmate_app/models/elementTasks/image_element.dart';
import 'package:taskmate_app/models/elementTasks/sublist.dart';
import 'package:taskmate_app/models/elementTasks/sublist_element.dart';
import 'package:taskmate_app/models/elementTasks/text_element.dart';
import 'package:taskmate_app/models/elementTasks/video_element.dart';
import 'package:taskmate_app/models/task.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taskmate_app/services/service_locator.dart';
import 'package:taskmate_app/states/tasks_loaded_state.dart';
import 'package:taskmate_app/ui/widgets/element_task_widget.dart';
import 'package:taskmate_app/ui/widgets/theme_widgets/custom_checkbox_widget.dart';
import 'package:uuid/uuid.dart';

import 'elements_widgets/element_add_button_widget.dart';

class TaskWidget extends StatefulWidget{

  Task actualTask;
  Function onDelete;

  TaskWidget({
    required this.actualTask,
    required this.onDelete,
  });

  @override
  State<StatefulWidget> createState() => _TaskWidget();

}

class _TaskWidget extends State<TaskWidget> with WidgetsBindingObserver {

  AppConfig appConfig = ServiceLocator.appConfig;
  TextEditingController textEditingController = TextEditingController();
  TasksLoadedState tasksLoadedState = ServiceLocator.taskLoadedState;

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void initState() {
    textEditingController.text = widget.actualTask.title;
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      tasksLoadedState.saveCurrentTask();
    } else if (state == AppLifecycleState.resumed) {
      tasksLoadedState.saveCurrentTask();
    } else if (state == AppLifecycleState.inactive) {
      tasksLoadedState.saveCurrentTask();
    } else if (state == AppLifecycleState.detached) {
      tasksLoadedState.saveCurrentTask();
    }
  }

  @override
  Widget build(BuildContext context) {
  const double padding = 10.0;
  const double margin = 10.0;
  const double radius = 10.0;
  const double opacity = 0.5;
  const double spreadRadius = 5;
  const double blur = 7;

  const scaleTransform = 1.5;

  Uuid uuid = Uuid();
  var task = widget.actualTask;

    return  Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: appConfig.theme.shadowColor,
            spreadRadius: spreadRadius,
            blurRadius: blur,
            offset: Offset(0, 3),
          ),
        ],
        color: Color(int.parse('0xff${task.hexColor.hex}')),
      ),
      margin: const EdgeInsets.all(margin),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(padding),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: textEditingController,
                    style: appConfig.theme.title,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: AppLocalizations.of(context)!.textFieldHint
                    ),
                    onEditingComplete: () {
                      task.title = textEditingController.text;
                      tasksLoadedState.saveCurrentTask();
                    },
                  ),
                ),
                Transform.scale(
                  scale: scaleTransform,
                  child: CustomCheckbox(
                      value: task.isChecked,
                      onChanged: (bool? newValue) {
                        setState(() {
                          task.isChecked = !task.isChecked;
                          tasksLoadedState.saveCurrentTask();
                        }
                        );
                      },
                    )
                )
              ],
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            separatorBuilder: (_, index) => SizedBox(height: padding),
            itemCount: task.elementList.length,
            itemBuilder: (_, index) {
              return ElementTaskWidget(
                  elementTask: task.elementList[index],
                  deleteSelf: () {
                    setState(() {
                      widget.actualTask.elementList.removeAt(index);
                      tasksLoadedState.saveCurrentTask();
                    });
                  },
              );
            },
          ),
          Row(
            children: [
              ElementAddButtonWidget(
                  task: task,
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      setState(() {
                        widget.onDelete();
                      });
                  });
              }),
              Spacer(),
              // TextElement
              ElementAddButtonWidget(
                  task: task,
                  icon: Icon(Icons.text_fields),
                  onPressed: () {
                    setState(() {
                      widget.actualTask.elementList.add(
                          TextElement(
                              elementId: uuid.v1(),
                              taskOrder: task.elementList.length,
                              text: ""
                          )
                      );
                    });
                  }),
              // ImageElement
              ElementAddButtonWidget(
                  task: task,
                  icon: Icon(Icons.image),
                  onPressed: () {
                    setState(() {
                      task.elementList.add(
                          ImageElement(
                              elementId: uuid.v1(),
                              taskOrder: task.elementList.length,
                              image: null)
                      );
                    });
                  }),
              /*
              ElementAddButtonWidget(
                  task: task,
                  icon: Icon(Icons.movie),
                  onPressed: () {
                    setState(() {
                      task.elementList.add(
                          VideoElementOwn(
                              elementId: uuid.v1(),
                              taskOrder: task.elementList.length,
                              video: null
                          )
                      );
                    });
                  }),
               */
              ElementAddButtonWidget(
                task: task,
                icon : Icon(Icons.list),
                onPressed: () {
                  setState(() {
                    task.elementList.add(
                        SublistElement(
                            elementId: uuid.v1(),
                            taskOrder: task.elementList.length,
                            title: "",
                            sublist: List<Sublist>.empty(growable: true)
                        )
                    );
                    if (task.elementList.last is SublistElement) {
                      var taskS = task.elementList.last as SublistElement;
                      taskS.sublist.add(Sublist(text: "", isChecked: false));
                    }
                  });
                },
              ),
            ],
          )

        ]
      ),
    );
  }


}



