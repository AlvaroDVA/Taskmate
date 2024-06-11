import 'dart:convert';
import 'dart:io';

import 'package:taskmate_app/models/elementTasks/element_task.dart';

class ImageElement extends ElementTask {

  File? image;

  ImageElement({
    required super.elementId,
    required super.taskOrder,
    required this.image
  });

  @override
  Map<String, dynamic> toJson() {
    if (image != null) {
      List<int>? imageBytes = image?.readAsBytesSync();
      return {
        "elementId" : elementId,
        "taskOrder" : taskOrder,
        "image" : base64Encode(imageBytes!),
      };
    }
    return {
      "elementId" : elementId,
      "taskOrder" : taskOrder,
      "image" : null
    };
  }

}