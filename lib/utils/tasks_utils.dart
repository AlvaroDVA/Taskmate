import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:taskmate_app/models/elementTasks/element_task.dart';
import 'package:taskmate_app/models/elementTasks/image_element.dart';
import 'package:taskmate_app/models/elementTasks/sublist_element.dart';
import 'package:taskmate_app/models/elementTasks/text_element.dart';
import 'package:taskmate_app/models/elementTasks/video_element.dart';
import 'package:uuid/uuid.dart';

import '../models/elementTasks/sublist.dart';

class TasksUtils {
 static ImageElement imageElementFromJson(Map<String, dynamic> json) {
   var image = json['image'];
   if (image != null) {
     Uint8List base64Data = base64Decode(image);

     // Obteniendo el directorio temporal de forma síncrona
     Directory tempDir = Directory.systemTemp;
     // Generando un nombre único para el archivo
     String tempPath = '${tempDir.path}/temp_image.png';

     // Escribir los datos de imagen en el archivo temporal
     File tempFile = File(tempPath);
     tempFile.writeAsBytesSync(base64Data);

     return ImageElement(
       elementId: json['elementId'],
       taskOrder: json['taskOrder'],
       image: tempFile,
     );
   }
   return ImageElement(
     elementId: json['elementId'],
     taskOrder: json['taskOrder'],
     image: null,
   );


  }

  static TextElement textElementFromJson(Map<String, dynamic> json) {

    String decodedText = traducirCaracteres(json['text']);

    return TextElement(
        elementId: json['elementId'],
        taskOrder: json['taskOrder'],
        text: decodedText
    );// Debería imprimir el texto correctamente decodificado
  }




  static VideoElementOwn videoElementFromJson(Map<String, dynamic> json) {
    return VideoElementOwn(
      elementId: json['elementId'],
      taskOrder: json['taskOrder'],
      video: json['video'],
    );
  }

  static ElementTask sublistElementFromJson(Map<String, dynamic> json) {

    List<Sublist> sublist = [];

    if (json['sublist'] != null) {
      json['sublist'].forEach((elementJson) {
        sublist.add(Sublist.fromJson(elementJson));
      });
    }

    return SublistElement(
        elementId: json['elementId'],
        taskOrder: json['taskOrder'],
        title: traducirCaracteres(json['title']),
        sublist: sublist
    );
  }

 static String traducirCaracteres(String json) {
   String encodedText = json;

   List<int> latin1Bytes = latin1.encode(encodedText);
   String decodedText = utf8.decode(latin1Bytes);
   return decodedText;
 }


}