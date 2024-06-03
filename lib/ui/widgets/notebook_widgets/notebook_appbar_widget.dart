import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../config/app_config.dart';
import '../../../services/service_locator.dart';
import '../theme_widgets/day_changer_icon_widget.dart';

class NotebookBarWidget extends StatelessWidget implements PreferredSizeWidget{
  NotebookBarWidget({
    super.key,
  });

  AppConfig appconfig = ServiceLocator.appConfig;

  @override
  Widget build(BuildContext context) {
    return AppBar(
        backgroundColor: appconfig.theme.primaryColor,
        leading : Row(
            children: [
              Builder(
                builder: (context1) {
                  final screenWidth = MediaQuery
                      .of(context)
                      .size
                      .width;
                  return Visibility(
                    visible: screenWidth <= 650,
                    child:
                    DayChangerIcon(
                      icon: Icons.arrow_forward_ios_outlined,
                      onPressed: () {
                        Scaffold.of(context1).openDrawer();
                      },
                    ),
                  );
                },
              )
            ])
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight * 1.45);
}
