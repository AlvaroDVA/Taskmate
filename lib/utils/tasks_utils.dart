import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:taskmate_app/models/elementTasks/element_task.dart';
import 'package:taskmate_app/models/elementTasks/image_element.dart';
import 'package:taskmate_app/models/elementTasks/sublist_element.dart';
import 'package:taskmate_app/models/elementTasks/text_element.dart';
import 'package:taskmate_app/models/elementTasks/video_element.dart';
import 'package:uuid/uuid.dart';

import '../models/elementTasks/sublist.dart';

class TasksUtils {
  static imageElementFromJson(Map<String, dynamic> json) {
    Uint8List base64Data = base64Decode(json['image']);

    File tempFile = File('temp_image.png');
    tempFile.writeAsBytesSync(base64Data);

    return ImageElement(
        elementId: json['elementId'],
        taskOrder: json['taskOrder'],
        image: tempFile
    );
  }

  static TextElement textElementFromJson(Map<String, dynamic> json) =>
      TextElement(
          elementId: json['elementId'],
          taskOrder: json['taskOrder'],
          text: json['text']
      );

  static VideoElement videoElementFromJson(Map<String, dynamic> json) {
    Uint8List base64Data = base64Decode(json['video']);

    File tempFile = File('temp_image.png');
    tempFile.writeAsBytesSync(base64Data);

    return VideoElement(
        elementId: json['elementId'],
        taskOrder: json['taskOrder'],
        video: tempFile
    );
  }

  static ElementTask sublistElementFromJson(Map<String, dynamic> json) {

    List<Sublist> sublist = [];

    if (json['sublist'] != null) {
      json['sublist'].forEach((elementJson) {
        sublist.add(Sublist.fromJson(elementJson));
      });
    }

    return SublistElement(
        elementId: json['elementId'],
        taskOrder: json['taskOrder'],
        title: json['title'],
        sublist: sublist
    );
  }


}