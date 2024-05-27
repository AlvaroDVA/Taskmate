import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../config/app_config.dart';
import '../../../services/service_locator.dart';

class MenuTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final Function() event;

  MenuTile({
    required this.icon,
    required this.text,
    required this.event,
  });

  AppConfig appConfig = ServiceLocator.appConfig;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: appConfig.theme.iconColor,
      ),
      title: Text(
          text,
          style: appConfig.theme.title
      ),
      onTap: event, // Aquí simplemente pasamos la función event sin llamarla
    );
  }
}