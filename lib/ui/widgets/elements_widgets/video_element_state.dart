import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../models/elementTasks/video_element.dart';
import '../element_task_widget.dart';

class VideoElementState extends State<ElementTaskWidget> {
  VideoElementOwn element;
  //late final WebViewController webViewController;

  VideoElementState({
    required this.element
  });

  @override
  void initState() {
    super.initState();
    //webViewController = WebViewController()
      //..loadRequest(Uri.parse(element.video != null ? element.video! : ""));
  }

  @override
  Widget build(BuildContext context) {
    return Text("");
    //return //WebViewWidget(controller: webViewController);
  }


  void _pickVideo() {
    var url = null;
    setState(() {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Enter Video URL'),
          content: TextField(
            onChanged: (value) {
              setState(() {
                url = value;
              });
            },
            decoration: InputDecoration(hintText: 'Enter URL'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('CANCEL'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  element.video = url;
                });
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    });
  }

  Future<void> _deleteVideo() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Eliminar video"),
        content: Text("¿Estás seguro de que deseas eliminar este video?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text("Cancelar"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text("Eliminar"),
          ),
        ],
      ),
    );

    if (confirmed != null && confirmed) {
      widget.deleteSelf();
    }
  }

}