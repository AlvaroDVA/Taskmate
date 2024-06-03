import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:taskmate_app/models/task.dart';

class Day {
  DateTime date;
  List<Task> todayTasks;
  bool loaded;

  Day ({
    required this.date,
    required this.todayTasks,
    required this.loaded,
  });

  factory Day.fromJson(Map<String, dynamic> json) {
    List<Task> tasks = [];
    if (json['tasks'] != null) {
      json['tasks'].forEach((elementJson) {
        tasks.add(Task.fromJson(elementJson));
      });
    }
    return Day(
      date: DateTime.parse(json['date']),
      todayTasks: tasks,
      loaded: true
    );
  }

  Map<String, dynamic> toJson(Day item) {

    List<Map<String, dynamic>> elements = [];
    for (var task in item.todayTasks) {
      elements.add(task.toJson());
    }

    return {
      'date' : DateFormat('yyyy-MM-dd').format(item.date),
      'todayTasks' : elements
    };
  }

  String getStringDay(BuildContext context) {
    Locale locale = Localizations.localeOf(context);
    final DateFormat dayFormat = DateFormat.EEEE(locale.toString());
    final DateFormat dateFormat = DateFormat('d \'de\' MMMM \'de\' yyyy', locale.toString());
    String dayOfWeek = dayFormat.format(this.date);
    String date = dateFormat.format(this.date);
    return '$dayOfWeek $date';
  }

}