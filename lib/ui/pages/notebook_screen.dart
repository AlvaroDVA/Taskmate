import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NotebookScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => NotebookScreenState();

}

class NotebookScreenState extends State<NotebookScreen>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Text(AppLocalizations.of(context)!.notebookScreenTitle)
      ),
    );
  }
}