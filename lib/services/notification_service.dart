import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taskmate_app/services/service_locator.dart';
import 'package:timezone/timezone.dart' as tz;

import '../config/app_config.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static Future<void> showNotification(BuildContext context) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
        'your channel id', 'your channel name',
        importance: Importance.max, priority: Priority.high,
        icon: 'drawable/calendar'
    );
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await _flutterLocalNotificationsPlugin.show(
      0,
      AppLocalizations.of(context)!.notificationHead,
      AppLocalizations.of(context)!.notificationBody,
      platformChannelSpecifics,
    );
  }

    static Future<void> showScheduledNotification(BuildContext context, int hour, int minute) async {
      await _flutterLocalNotificationsPlugin.cancel(0);

      tz.TZDateTime now = tz.TZDateTime.now(tz.local);

      // TODO FIX DE HORA PARA ESPAÑA APLICADO, FALTARIA SEGUN LA ZONA HORARIA DEL MOVIL
      tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour - 2, minute);

      const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
          'your channel id', 'your channel name',
          importance: Importance.max, priority: Priority.high,
          icon: 'drawable/calendar'
      );
      const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

      await _flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        AppLocalizations.of(context)!.notificationHead,
        AppLocalizations.of(context)!.notificationBody,
        scheduledDate,
        platformChannelSpecifics,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );

      print('Notification scheduled for: $scheduledDate');
    }


}
