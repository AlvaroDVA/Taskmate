
import 'package:flutter/material.dart';
import 'package:taskmate_app/config/app_config.dart';
import 'package:taskmate_app/models/elementTasks/image_element.dart';
import 'package:taskmate_app/models/elementTasks/text_element.dart';
import 'package:taskmate_app/models/elementTasks/video_element.dart';
import 'package:taskmate_app/models/task.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taskmate_app/services/service_locator.dart';
import 'package:taskmate_app/ui/widgets/element_task_widget.dart';
import 'package:uuid/uuid.dart';

class TaskWidget extends StatefulWidget{

  final Task actualTask;

  TaskWidget({
    required this.actualTask
  });

  @override
  State<StatefulWidget> createState() => _TaskWidget();
}

class _TaskWidget extends State<TaskWidget> {

  AppConfig appConfig = ServiceLocator.appConfig;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
  const double padding = 20.0;
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
            color: Colors.grey.withOpacity(opacity),
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
                    controller: TextEditingController(text: task.title),
                    style: appConfig.theme.title,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: AppLocalizations.of(context)!.textFieldHint
                    ),
                  ),
                ),
                Transform.scale(
                  scale: scaleTransform,
                  child: Checkbox(
                      value: task.isChecked,
                      onChanged: (_) {
                        setState(() {
                          task.isChecked = !task.isChecked;
                        });
                      },
                  ),
                )
              ],
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            separatorBuilder: (_, index) => SizedBox(height: padding),
            itemCount: task.elementList.length,
            itemBuilder: (_, index) {
              return ElementTaskWidget(elementTask: task.elementList[index]);
            },
          ),
          Row(
            children: [
              Spacer(),
              // TextElement
              Padding(
                padding: const EdgeInsets.all(padding),
                child: Container(
                  decoration: BoxDecoration(
                    color: appConfig.theme.lightColor2,
                    border: Border.all(
                      color: appConfig.theme.darkAuxColor,
                      width: 2.0,
                    )
                  ),
                  child: IconButton(
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
                      },
                      icon: Icon(Icons.text_fields)
                  ),
                ),
              ),
              // ImageElement
              Padding(
                padding: const EdgeInsets.all(padding),
                child: Container(
                  decoration: BoxDecoration(
                      color: appConfig.theme.lightColor2,
                      border: Border.all(
                        color: appConfig.theme.darkAuxColor,
                        width: 2.0,
                      )
                  ),
                  child: IconButton(
                      onPressed: () {
                        setState(() {
                          task.elementList.add(
                              ImageElement(
                                  elementId: uuid.v1(),
                                  taskOrder: task.elementList.length,
                                  image: null)
                          );
                        });
                      },
                      icon: Icon(Icons.image)
                  ),
                ),
              ),
              // VideoElement
              Padding(
                padding: const EdgeInsets.all(padding),
                child: Container(
                  decoration: BoxDecoration(
                      color: appConfig.theme.lightColor2,
                      border: Border.all(
                        color: appConfig.theme.darkAuxColor,
                        width: 2.0,
                      )
                  ),
                  child: IconButton(
                      onPressed: () {
                        setState(() {
                          task.elementList.add(
                            VideoElement(
                                elementId: uuid.v1(),
                                taskOrder: task.elementList.length,
                                video: null
                            )
                          );
                        });
                      },
                      icon: Icon(Icons.movie)
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(padding),
                child: Container(
                  decoration: BoxDecoration(
                      color: appConfig.theme.lightColor2,
                      border: Border.all(
                        color: appConfig.theme.darkAuxColor,
                        width: 2.0,
                      )
                  ),
                  child: IconButton(
                      onPressed: () {
                        setState(() {

                        });
                      },
                      icon: Icon(Icons.text_fields)
                  ),
                ),
              ),

            ],
          )

        ]
      ),
    );
  }
}