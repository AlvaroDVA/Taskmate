import 'package:taskmate_app/models/task.dart';

class Day {
  DateTime date;
  List<Task> todayTasks;

  Day ({
    required this.date,
    required this.todayTasks,
  });

  factory Day.fromJson(Map<String, dynamic> json) {
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