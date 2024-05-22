import 'dart:convert';
import 'dart:io';

import 'package:taskmate_app/models/elementTasks/element_task.dart';

class VideoElement extends ElementTask {

  File? video;

  VideoElement({
    required super.elementId,
    required super.taskOrder,
    required this.video
  });

  @override
  Map<String, dynamic> toJson() {
    List<int>? videoBytes = video?.readAsBytesSync();
    var send;
    if (videoBytes != null) {
      send = base64Encode(videoBytes);
    }else {
      send = "none";
    }
    return {
      "elementId" : elementId,
      "taskOrder" : taskOrder,
      "video" : send,
    };
  }

}