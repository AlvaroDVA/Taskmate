import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taskmate_app/exceptions/tasks_exceptions.dart';
import 'package:taskmate_app/models/elementTasks/element_task.dart';
import 'package:taskmate_app/models/elementTasks/sublist_element.dart';
import 'package:taskmate_app/models/elementTasks/text_element.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taskmate_app/services/service_locator.dart';

import '../../config/app_config.dart';
import '../../models/elementTasks/image_element.dart';
import '../../models/elementTasks/video_element.dart';
import 'elements_widgets/imagen_element_state.dart';
import 'elements_widgets/sublist_element_state.dart';
import 'elements_widgets/text_element_state.dart';
import 'elements_widgets/video_element_state.dart';

class ElementTaskWidget extends StatefulWidget {
  final ElementTask elementTask;
  Function deleteSelf;

  ElementTaskWidget({super.key,
    required this.elementTask,
    required this.deleteSelf,});

  @override
  State<StatefulWidget> createState() => generateElementWidgetState();

  State<ElementTaskWidget> generateElementWidgetState() {
    switch (elementTask.runtimeType) {
      case TextElement:
        return TextElementState(element: elementTask as TextElement);
      case ImageElement:
        return ImageElementState(element: elementTask as ImageElement);
      case SublistElement:
        return SublistElementState(element: elementTask as SublistElement);
      case VideoElementOwn:
        return VideoElementState(element: elementTask as VideoElementOwn);
      default:
        throw TaskElementNotExist("This element task type not exist");
    }
  }



}

