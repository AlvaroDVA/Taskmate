import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:taskmate_app/services/service_locator.dart';
import 'package:taskmate_app/states/notebook_state.dart';
import 'package:taskmate_app/ui/pages/notebook_screen.dart';

import '../../../config/app_config.dart';
import '../../../models/notebook_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PageNotebookWidget extends StatefulWidget {
  const PageNotebookWidget({super.key});

  @override
  State<StatefulWidget> createState() => PageNotebookWidgetState();

}

class PageNotebookWidgetState extends State<PageNotebookWidget> {

  AppConfig appconfig = ServiceLocator.appConfig;
  NotebookState notebookState = ServiceLocator.notebookState;
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    textEditingController.addListener(() {
      notebookState.currentPage.text = textEditingController.text;
    });
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NotebookState>(
      builder: (BuildContext context, NotebookState notebookState, Widget? child) {
        textEditingController.text = notebookState.currentPage.text;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 40.0, right: 40.0),
              child: SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height / 1.2,
                  width: MediaQuery.of(context).size.width,
                  child: TextField(
                    controller: textEditingController,
                    maxLines: null, // Permite múltiples líneas
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.writeHereHint,
                      hintStyle: appconfig.theme.title,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(16.0),
                    ),
                    style: appconfig.theme.title,
                    keyboardType: TextInputType.multiline,
                    onEditingComplete: () {
                      notebookState.saveNotebook();
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

