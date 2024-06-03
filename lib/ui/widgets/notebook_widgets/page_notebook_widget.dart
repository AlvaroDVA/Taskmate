import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:taskmate_app/services/service_locator.dart';
import 'package:taskmate_app/states/notebook_state.dart';

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

  final editorState = EditorState.blank(withInitialText: true);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<NotebookState>(
      builder: (BuildContext context, NotebookState notebookState, Widget? child) {
        return Container(
          decoration: BoxDecoration(
            color: appconfig.theme.lightColor,
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.sizeOf(context).height,
                  width: MediaQuery.sizeOf(context).width,
                  child: AppFlowyEditor(
                    editorState: editorState,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

