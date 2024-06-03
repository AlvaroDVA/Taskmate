import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../config/app_config.dart';
import '../../../services/service_locator.dart';

class SimpleAppbar extends StatelessWidget implements PreferredSizeWidget {
  SimpleAppbar({
    super.key,
    required this.text,
  });

  final String text;
  AppConfig appConfig = ServiceLocator.appConfig;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: appConfig.theme.primaryColor,
      automaticallyImplyLeading: MediaQuery.of(context).size.width <= 650,
      leading: MediaQuery.of(context).size.width <= 650 ? IconButton(
        icon: Icon(Icons.menu, color: appConfig.theme.auxColor),
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
      ) : null,
      title: Text(
        text,
        style: appConfig.theme.title,
      ),
    );
  }

  @override
  Size get preferredSize {
    if (Platform.isAndroid) {
      return Size.fromHeight(kToolbarHeight * 1.58);
    } else {
      return Size.fromHeight(kToolbarHeight * 1.43);
    }
  }

}