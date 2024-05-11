import 'package:taskmate_app/storages/istorage.dart';

import '../models/day.dart';
import '../models/task.dart';

class DayStorage implements IStorage<Day> {

  @override
  fromJson(Map<String, dynamic> json) {
    List<Task> tasks = [];

    if (json['todayTask'] != null) {
      json['elementList'].forEach((elementJson) {
        tasks.add(Task.fromJson(elementJson));
      });
    }

    return Day(
      date: json['date'],
      todayTasks: tasks,
    );
  }

  @override
  Map<String, dynamic> toJson(Day item) {

    List<Map<String, dynamic>> elements = [];
    for (var task in item.todayTasks) {
      elements.add(task.toJson());
    }

    return {
      'date' : item.date,
      'todayTasks' : elements
    };
  }

}