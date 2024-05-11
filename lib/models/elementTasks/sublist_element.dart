import 'package:taskmate_app/models/elementTasks/element_task.dart';
import 'package:taskmate_app/models/elementTasks/sublist.dart';

class SublistElement extends ElementTask {

  String title;
  List<Sublist> sublist;

  SublistElement({
    required super.elementId,
    required super.taskOrder,
    required this.title,
    required this.sublist,
  });

  @override
  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> elements = [];
    for (var sl in sublist) {
      elements.add(sl.toJson());
    }
    return {
      'elementId' : elementId,
      'taskOrder' : taskOrder,
      'title' : title,
      'sublist' : elements
    };
  }

}