import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../config/app_config.dart';
import '../../../services/service_locator.dart';

class SettingsCard extends StatelessWidget {
  final IconData leadingIcon;
  final String title;
  final Function() onTap;

  SettingsCard({
    required this.leadingIcon,
    required this.title,
    required this.onTap,
  });

  AppConfig appConfig = ServiceLocator.appConfig;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: appConfig.theme.secondaryColor,
      child: ListTile(
        leading: Icon(
          leadingIcon,
          color: appConfig.theme.iconColor,
        ),
        title: Text(
          title,
          style: appConfig.theme.title,
        ),
        onTap: onTap,
      ),
    );
  }
}