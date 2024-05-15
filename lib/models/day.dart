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
    print("Tasks : $tasks");
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
      'date' : item.date,
      'todayTasks' : elements
    };
  }

}