import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:taskmate_app/models/notebook_page.dart';
import 'package:taskmate_app/services/service_locator.dart';

import '../../config/app_config.dart';
import '../../states/notebook_state.dart';
import '../widgets/main_menu.dart';
import '../widgets/notebook_widgets/notebook_appbar_widget.dart';
import '../widgets/notebook_widgets/page_notebook_widget.dart';
import '../widgets/theme_widgets/day_changer_icon_widget.dart';

class NotebookScreen extends StatefulWidget{
  const NotebookScreen({super.key});

  @override
  State<StatefulWidget> createState() => NotebookScreenState();

}
class NotebookScreenState extends State<NotebookScreen> {
  AppConfig appconfig = ServiceLocator.appConfig;
  NotebookState notebookState = ServiceLocator.notebookState;
  @override
  void initState() {
    super.initState();
    notebookState.initNotebook();
  }

  @override
  void dispose() {
    notebookState.saveNotebook();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final breakpoint = 650.0;
    return Consumer<NotebookState>(
      builder: (context, notebookState, child) {
        if (notebookState.pages.isEmpty) {
          return Scaffold(
            drawerEnableOpenDragGesture: screenWidth < breakpoint,
            backgroundColor: appconfig.theme.notebookBackgroundColor,
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          return Scaffold(
            drawerEnableOpenDragGesture: screenWidth < breakpoint,
            resizeToAvoidBottomInset: false,
            backgroundColor: appconfig.theme.notebookBackgroundColor,
            drawer: MainMenu(),
            appBar: NotebookBarWidget(),
            body: GestureDetector(
              onHorizontalDragEnd: (details) {
                if (details.primaryVelocity != null) {
                  if (details.primaryVelocity! < 0) {
                    notebookState.nextPage();
                  } else if (details.primaryVelocity! > 0) {
                    notebookState.previousPage();
                  }
                }
              },
              child: Stack(
                children: [
                  PageView.builder(
                    itemCount: notebookState.pages.length,
                    controller: PageController(initialPage: notebookState.currentPageIndex),
                    onPageChanged: (index) {
                      notebookState.goToPage(index);
                    },
                    itemBuilder: (context, index) {
                      return OverflowBox(child: PageNotebookWidget());
                    },
                  ),
                  if (notebookState.currentPageIndex > 0)
                    Positioned(
                      left: 16.0,
                      top: MediaQuery.of(context).size.height / 2 - 24,
                      child: IconButton(
                        color: appconfig.theme.auxColor,
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          notebookState.previousPage();
                        },
                      ),
                    ),
                  Positioned(
                    right: 16.0,
                    top: MediaQuery.of(context).size.height / 2 - 24,
                    child: IconButton(
                      color: appconfig.theme.auxColor,
                      icon: Icon(Icons.arrow_forward),
                      onPressed: () {
                        notebookState.nextPage();
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

}


