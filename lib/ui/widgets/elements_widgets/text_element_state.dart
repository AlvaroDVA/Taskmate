import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../config/app_config.dart';
import '../../../models/elementTasks/text_element.dart';
import '../../../services/service_locator.dart';
import '../element_task_widget.dart';

class TextElementState extends State<ElementTaskWidget>{

  AppConfig appConfig = ServiceLocator.appConfig;
  TextElement element;
  TextEditingController textEditingController = TextEditingController();

  TextElementState({required this.element}) {
    textEditingController.text = element.text;
  }

  @override
  Widget build(BuildContext context) {
    double _padding = 8;


    return Padding(
      padding: EdgeInsets.all(_padding),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all()
        ),
        child: Padding(
          padding: EdgeInsets.all(_padding / 2),
          child: TextField(
              controller: textEditingController,
              onChanged: (value) {
                element.text = value;
              },
              maxLines: null,
              minLines: 1,
              style: appConfig.theme.title,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: AppLocalizations.of(context)!.textFieldHint
              )
          ),
        ),
      ),
    );
  }
}