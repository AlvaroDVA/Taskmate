import '../enums/color_task.dart';
import 'elementTasks/element_task.dart';

class Task {

  int idTask;
  String title;
  bool isChecked;
  ColorTask hexColor;
  List<ElementTask> elementList;

  Task ({
    required this.idTask,
    required this.title,
    required this.isChecked,
    required this.hexColor,
    required this.elementList
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    List<ElementTask> elements = [];
    if (json['elementList'] != null) {
      json['elementList'].forEach((elementJson) {
        elements.add(ElementTask.fromJson(elementJson));
      });
    }

    return Task(
      idTask: json['idTask'],
      title: json['title'],
      isChecked: json['isChecked'],
      hexColor: ColorTask.values.firstWhere((color) => color.hex == json['colorHex']),
      elementList: elements,
    );
  }

  Map<String, dynamic> toJson() {

    List<Map<String, dynamic>> elementsJson = [];
    for (var element in elementList) {
      elementsJson.add(element.toJson());
    }

    return {
      'idTask': idTask.toString(),
      'title': title,
      'isChecked': isChecked,
      'hexColor': hexColor.hex,
      'elementList': elementsJson,
    };
  }

}