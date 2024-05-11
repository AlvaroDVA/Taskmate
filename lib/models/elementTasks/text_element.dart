import 'package:taskmate_app/models/elementTasks/element_task.dart';

class TextElement extends ElementTask {

  String text;

  TextElement({
    required super.elementId,
    required super.taskOrder,
    required this.text
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      "elementId" : elementId,
      "taskOrder" : taskOrder,
      "text" : text,
    };
  }

}