import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:taskmate_app/config/app_config.dart';
import 'package:taskmate_app/services/service_locator.dart';
import 'package:taskmate_app/states/screens_state.dart';
import 'package:taskmate_app/states/tasks_loaded_state.dart';
import 'package:taskmate_app/ui/widgets/main_menu.dart';
import 'package:taskmate_app/ui/widgets/theme_widgets/simple_appbar.dart';

class CalendarScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CalendarScreenState();

}

class CalendarScreenState extends State<CalendarScreen>{
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  TasksLoadedState tasksLoadedState = ServiceLocator.taskLoadedState;
  ScreenState screenState = ServiceLocator.screenState;
  AppConfig appConfig = ServiceLocator.appConfig;

  @override
  void initState() {
    _selectedDay = tasksLoadedState.currentDay.date;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final breakpoint = 650.0;
    return Scaffold(
      drawerEnableOpenDragGesture: screenWidth < breakpoint,
      drawer: MainMenu(),
      backgroundColor: appConfig.theme.primaryColor,
      appBar: SimpleAppbar(text: AppLocalizations.of
        (context)!.calendarPageTitle),
      body: Center(
        child: Column(
          children: [
            TableCalendar(
              locale: appConfig.locale.languageCode,
              firstDay: DateTime.utc(2024, 01, 01),
              lastDay: DateTime.utc(2090, 3, 14),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              headerStyle: HeaderStyle(
                titleTextStyle: appConfig.theme.title,
                titleCentered: true,
                leftChevronIcon: Icon(
                  Icons.chevron_left,
                  color: Colors.white,
                ),
                rightChevronIcon: Icon(
                  Icons.chevron_right,
                  color: Colors.white,
                ),
              ),
              availableCalendarFormats: const {
                CalendarFormat.month: 'Month',
              },
              onDaySelected: (selectedDay, focusedDay) async {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
                  await tasksLoadedState.setCurrentDay(selectedDay);
                  screenState.setTaskScreen();
              },
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
              calendarStyle: CalendarStyle(
                outsideDaysVisible: true,
                defaultTextStyle: appConfig.theme.defaultTextStyle,
                weekendTextStyle: appConfig.theme.weekendTextStyle,
                holidayTextStyle: appConfig.theme.holidayTextStyle,
                outsideTextStyle: appConfig.theme.outsideTextStyle,
                selectedTextStyle: appConfig.theme.selectedTextStyle,
                todayTextStyle: appConfig.theme.todayTextStyle,
                selectedDecoration: appConfig.theme.selectedDecoration,
                todayDecoration: appConfig.theme.todayDecoration,
                defaultDecoration: appConfig.theme.defaultDecoration,
                weekendDecoration: appConfig.theme.weekendDecoration,
                outsideDecoration: appConfig.theme.outsideDecoration,
                markerDecoration: appConfig.theme.markedDecoration,
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekendStyle: appConfig.theme.dayWeekTitle,
                weekdayStyle: appConfig.theme.dayWeekTitle,
              ),
            ),
          ],
        ),
      ),
    );
  }

}