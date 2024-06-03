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

  AppConfig appconfig =  ServiceLocator.appConfig;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appconfig.theme.primaryColor,
      drawer: MainMenu(),
      appBar: NotebookBarWidget(),
      body: Consumer<NotebookState>(
        builder: (context, notebookState, child) {
          return GestureDetector(
            onHorizontalDragEnd: (details) {
              if (details.primaryVelocity != null) {
                if (details.primaryVelocity! < 0) {
                  setState(() {
                    notebookState.nextPage();
                  });

                } else if (details.primaryVelocity! > 0) {
                  setState(() {
                    notebookState.previousPage();
                  });
                }
              }
            },
            child: Stack(
              children: [
                PageView.builder(
                  itemCount: notebookState.pages.length,
                  controller: PageController(initialPage: notebookState.currentPageIndex),
                  onPageChanged: (index) {
                    setState(() {
                      notebookState.goToPage(index);
                    });
                  },
                  itemBuilder: (context, index) {
                    return PageNotebookWidget();
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
                        setState(() {
                          notebookState.previousPage();
                        });
                      },
                    ),
                  ),
                if (notebookState.currentPageIndex < notebookState.pages.length - 1)
                  Positioned(
                    right: 16.0,
                    top: MediaQuery.of(context).size.height / 2 - 24,
                    child: IconButton(
                      color: appconfig.theme.auxColor,
                      icon: Icon(Icons.arrow_forward),
                      onPressed: () {
                        setState(() {
                          notebookState.nextPage();
                        });
                      },
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}


