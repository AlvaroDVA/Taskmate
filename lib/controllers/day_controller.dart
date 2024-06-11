import 'package:intl/intl.dart';
import 'package:taskmate_app/services/service_locator.dart';

import '../models/day.dart';
import '../models/user.dart';
import '../services/day_service.dart';

class DayController {

  DayService dayService = ServiceLocator.dayService;

  Future<Day> loadDayTasks(User usuario, DateTime date) async {
    return await dayService.loadDayTasks(usuario, DateFormat('yyyy-MM-dd').format(date));
  }

  Future<void> saveDay(Day currentDay, User? currentUser) async {
    await dayService.saveDayTasks(currentDay, currentUser);
  }

}

