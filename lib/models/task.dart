import '../enums/color_task.dart';
import 'elementTasks/element_task.dart';

class Task {

  BigInt idTask;
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
    // Convertir la lista de elementos del JSON a una lista de objetos ElementTask
    List<ElementTask> elements = [];
    if (json['elementList'] != null) {
      json['elementList'].forEach((elementJson) {
        elements.add(ElementTask.fromJson(elementJson));
      });
    }

    return Task(
      idTask: BigInt.parse(json['idTask']),
      title: json['title'],
      isChecked: json['isChecked'],
      hexColor: ColorTask.values.firstWhere((color) => color.hex == json['hexColor']),
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