import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../../config/app_config.dart';
import '../../../models/task.dart';
import '../../../services/service_locator.dart';

class ElementAddButtonWidget extends StatelessWidget {

  var padding = 10.0;
  Uuid uuid = Uuid();

  Task task;
  Icon icon;
  Function() onPressed;

  ElementAddButtonWidget({
    required this.task,
    required this.icon,
    required this.onPressed
  });

  AppConfig appConfig = ServiceLocator.appConfig;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding),
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
              onPressed();
            },
            icon: icon
        ),
      ),
    );
  }

}