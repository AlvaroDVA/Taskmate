import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taskmate_app/config/app_config.dart';
import 'package:taskmate_app/services/service_locator.dart';

class DayChangerIcon extends StatelessWidget {
  final IconData icon;
  final Function() onPressed;

  DayChangerIcon({
    required this.icon,
    required this.onPressed,
  });

  AppConfig appConfig = ServiceLocator.appConfig;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        icon,
        color: appConfig.theme.iconColor,
      ),
    );
  }
}