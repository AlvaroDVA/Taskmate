import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:taskmate_app/exceptions/tasks_exceptions.dart';
import 'package:taskmate_app/models/elementTasks/element_task.dart';
import 'package:taskmate_app/models/elementTasks/sublist_element.dart';
import 'package:taskmate_app/models/elementTasks/text_element.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:video_player/video_player.dart';
import 'package:video_player_win/video_player_win.dart';


import '../../config/app_config.dart';
import '../../models/elementTasks/image_element.dart';
import '../../models/elementTasks/video_element.dart';
import 'elements_widgets/sublist_element_state.dart';

class ElementTaskWidget extends StatefulWidget {
  final ElementTask elementTask;

  ElementTaskWidget({super.key, required this.elementTask}) {
    print(elementTask.runtimeType);
  }

  @override
  State<StatefulWidget> createState() => generateElementWidgetState();

  State<ElementTaskWidget> generateElementWidgetState() {
    switch (elementTask.runtimeType) {
      case TextElement:
        return _TextElementState(element: elementTask as TextElement);
      case ImageElement:
        return _ImageElementState(element: elementTask as ImageElement);
      case SublistElement:
        return SublistElementState(element: elementTask as SublistElement);
      case VideoElement:
        return _VideoElementState(element: elementTask as VideoElement);
      default:
        throw TaskElementNotExist("This element task type not exist");
    }
  }

}

class _ImageElementState extends State<ElementTaskWidget> {
  ImageElement element;

  _ImageElementState({
    required this.element,
  });

  Future<void> _pickImage() async {
    if (Platform.isAndroid || Platform.isIOS) {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          element.image = File(pickedFile.path);
        });
      }
    } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);

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
      setState(() {
        element.image = null;
      });
    }
  }
}

class _TextElementState extends State<ElementTaskWidget>{

  late AppConfig appConfig;
  TextElement element;
  TextEditingController textEditingController = TextEditingController();

  _TextElementState({required this.element}) {
    textEditingController.text = element.text;
  }

  @override
  Widget build(BuildContext context) {
    appConfig = Provider.of<AppConfig>(context);
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



class _VideoElementState extends State<ElementTaskWidget> {
  final picker = ImagePicker();
  WinVideoPlayerController? _controller;
  VideoElement element;

  _VideoElementState({
      required this.element,
  });

  @override
  void initState() {
    super.initState();
    if (element.video != null) {
      _initializeVideo(element.video!);
    }
  }

  void _initializeVideo(File videoFile) {
    _controller = WinVideoPlayerController.file(videoFile)
        ..initialize().then((_) {
          setState(() {
            if (_controller!.value.isInitialized) {
              _controller?.pause();
            }
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (element.video == null) {
          _selectVideo();
        } else {
          _togglePlayPause();
        }
      },
      onLongPress: () {
        if (element.video != null) {
          _deleteVideo();
        }
      },
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            border: Border.all(color: Colors.black54),
          ),
          child: element.video != null
              ? _controller!.value.isInitialized
              ? AspectRatio(
                aspectRatio: _controller!.value.aspectRatio,
                child: WinVideoPlayer(_controller!),
              )
              : const Center(child: CircularProgressIndicator())
              : Center(
            child: Text(
              AppLocalizations.of(context)!.videoSelectorText,
              style: TextStyle(color: Colors.black54),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _deleteVideo() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.deleteVideoContent),
        content: Text(AppLocalizations.of(context)!.deleteVideoContent),
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
      setState(() {
        element.video = null;
        _controller?.pause();
      });
    }
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller!.value.isPlaying) {
        _controller!.pause();
      } else {
        _controller!.play();
      }
    });
  }

  Future<void> _selectVideo() async {
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        element.video = File(pickedFile.path);
        _initializeVideo(element.video!);
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}