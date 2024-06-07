import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../models/elementTasks/image_element.dart';
import '../element_task_widget.dart';

class ImageElementState extends State<ElementTaskWidget> {
  ImageElement element;

  ImageElementState({
    required this.element,
  });

  Future<void> _pickImage() async {
    if (Platform.isAndroid || Platform.isIOS) {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(
          source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          element.image = File(pickedFile.path);
        });
      }
    } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.image);

      if (result != null && result.files.single.path != null) {
        setState(() {
          element.image = File(result.files.single.path!);
        });
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickImage,
      onLongPress: _deleteImage,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            border: Border.all(color: Colors.black54),
          ),
          child: element.image != null
              ? Image.file(element.image!, fit: BoxFit.contain)
              : Container(
            width: 200,
            height: 200,
            child: Center(
              child: Text(
                AppLocalizations.of(context)!.imageSelectorText,
                style: TextStyle(color: Colors.black54),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _deleteImage() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.deleteImageTitle),
        content: Text(AppLocalizations.of(context)!.deleteImageText),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(AppLocalizations.of(context)!.cancelButton),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(AppLocalizations.of(context)!.deleteButton),
          ),
        ],
      ),
    );

    if (confirmed != null && confirmed) {
      widget.deleteSelf();
    }
  }
}