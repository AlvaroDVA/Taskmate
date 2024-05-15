import 'package:taskmate_app/models/task.dart';
import 'package:taskmate_app/rest/tasks_api_rest.dart';
import 'package:taskmate_app/services/service_locator.dart';

import '../models/day.dart';
import '../models/user.dart';

class DayService {

  TasksApiRest tasksApiRest = ServiceLocator.tasksApiRest;

  Future<Day> loadDayTasks(User usuario, String date) async {
    Map<String, dynamic> res = await tasksApiRest.getDayTasks(usuario, date);
    if (res['error'] != null) {
      return Day(
        date : DateTime.parse(date),
        todayTasks: [],
        loaded: false
      );
    }
    res.addAll({"date" : date});

    return Day.fromJson(res);
  }

}