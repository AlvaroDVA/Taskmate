

import 'dart:convert';
import 'dart:io';

import 'package:taskmate_app/exceptions/tasks_exceptions.dart';
import 'package:taskmate_app/utils/tasks_utils.dart';
import 'package:uuid/uuid.dart';

abstract class ElementTask {

  Uuid elementId;
  int taskOrder;

  ElementTask({
    required this.elementId,
    required this.taskOrder,
  });

  factory ElementTask.fromJson(Map<String, dynamic> json) {
    if (json['image'] != null) {
      return TasksUtils.imageElementFromJson(json);
    } else if (json['text'] != null) {
      return TasksUtils.textElementFromJson(json);
    } else if (json['video'] != null) {
      return TasksUtils.videoElementFromJson(json);
    } else if (json['title'] != null && json['sublist'] != null) {
      return TasksUtils.sublistElementFromJson(json);
    }
    throw TaskJsonException("Tarea mal formada en el Json");
  }

  Map<String, dynamic> toJson();

}