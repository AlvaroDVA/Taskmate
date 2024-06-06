import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskmate_app/states/notebook_state.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../config/app_config.dart';
import '../../../services/service_locator.dart';
import '../theme_widgets/day_changer_icon_widget.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotebookBarWidget extends StatelessWidget implements PreferredSizeWidget {
  NotebookBarWidget({super.key});

  AppConfig appconfig = ServiceLocator.appConfig;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: appconfig.theme.notebookBackgroundColor,
      leading: Builder(
        builder: (context1) {
          final screenWidth = MediaQuery.of(context).size.width;
          return Visibility(
            visible: screenWidth <= 650,
            child: DayChangerIcon(
              icon: Icons.arrow_forward_ios_outlined,
              onPressed: () {
                Scaffold.of(context1).openDrawer();
              },
            ),
          );
        },
      ),
      title: Consumer<NotebookState>(
        builder: (BuildContext context, NotebookState value, Widget? child) {
          return Center(
            child: Text(
              "${AppLocalizations.of(context)!.notebookPageText} ${value.currentPage.pageNumber}",
              style: appconfig.theme.title,
              textAlign: TextAlign.center,
            ),
          );
        },
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
