import 'package:taskmate_app/models/task.dart';

class Day {
  DateTime date;
  List<Task> todayTasks;

  Day ({
    required this.date,
    required this.todayTasks,
  });

}