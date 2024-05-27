import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CalendarScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CalendarScreenState();

}

class CalendarScreenState extends State<CalendarScreen>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(AppLocalizations.of(context)!.calendarPageTitle)
      ),
    );
  }
}