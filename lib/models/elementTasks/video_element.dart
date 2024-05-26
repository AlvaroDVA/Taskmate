import 'dart:convert';
import 'dart:io';

import 'package:taskmate_app/models/elementTasks/element_task.dart';

class VideoElementOwn extends ElementTask {

  String? video;

  VideoElementOwn({
    required super.elementId,
    required super.taskOrder,
    required this.video
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      "elementId" : elementId,
      "taskOrder" : taskOrder,
      "video" : video,
    };

  }

}