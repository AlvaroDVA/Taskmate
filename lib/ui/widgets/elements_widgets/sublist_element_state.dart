import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../config/app_config.dart';
import '../../../models/elementTasks/sublist.dart';
import '../../../models/elementTasks/sublist_element.dart';
import '../../../services/service_locator.dart';
import '../element_task_widget.dart';

class SublistElementState extends State<ElementTaskWidget> {
  final SublistElement element;
  late final AppConfig appConfig;
  late List<TextEditingController> _sublistControllers;

  SublistElementState({
    required this.element,
  }) {
    appConfig = ServiceLocator.appConfig;
    print("Check ${element.sublist.length}");
    _sublistControllers = element.sublist.map((subElement) {
      return TextEditingController(text: subElement.text);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    const double _padding = 20.0;

    return Center(
      child: Column(
        children: [
          sublistTitle(_padding),
          sublistBody(_padding),
          sublistButton(_padding)
        ],
      ),
    );
  }

  Row sublistButton(double _padding) {
    return Row(
          children: [
            Spacer(),
            Padding(
              padding: EdgeInsets.all(_padding),
              child: Container(
                decoration: BoxDecoration(
                  color: appConfig.theme.lightColor,
                  border: Border.all(
                    color: Colors.black,
                    width: 2.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10.0,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: IconButton(
                    onPressed: () {
                      setState(() {
                        element.sublist.add(Sublist(text: "", isChecked: false));
                        _sublistControllers.add(TextEditingController(text: element.sublist.last.text));
                      });
                    },
                    icon: Icon(Icons.add)),
              ),
            )
          ],
        );
  }

  Padding sublistBody(double _padding) {
    return Padding(
      padding: EdgeInsets.all(_padding),
      child: Container(
        decoration: BoxDecoration(
          color: appConfig.theme.lightColor,
          border: Border.all(
            color: Colors.black,
            width: 2.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: SizedBox(
          height: (100.0 * element.sublist.length),
          child: ListView.separated(
            itemCount: element.sublist.length,
            separatorBuilder: (_, index) => SizedBox(height: _padding),
            itemBuilder: (_, index) {
              return Padding(
                padding: EdgeInsets.all(_padding / 1.25),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _sublistControllers[index],
                        onEditingComplete: () {
                          setState(() {
                            element.sublist[index].text = _sublistControllers[index].text;
                          });
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          icon: IconButton(
                            icon : Icon(Icons.delete),
                            onPressed: () {
                              setState(() {
                                element.sublist.remove(element.sublist[index]);
                                _sublistControllers.removeAt(index);
                              });
                            },
                          )
                        ),
                      ),
                    ),
                    Spacer(),
                    Checkbox(
                      value: element.sublist[index].isChecked,
                      onChanged: (_) {
                        setState(() {
                          element.sublist[index].isChecked = !element.sublist[index].isChecked;
                        });
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Padding sublistTitle(double padding) {
    return Padding(
      padding:  EdgeInsets.all(padding),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: TextEditingController(text: element.title),
              onEditingComplete: () {
                setState(() {
                  element.title = element.title;
                  print(element.title);
                });
              },
              style: appConfig.theme.title,
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
            ),
          ),
          Spacer(),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 2.0),
              color: appConfig.theme.lightColor,
            ),
            child: Padding(
              padding:  EdgeInsets.all(padding / 4),
              child: Text(
                "${element.sublist.where((elt) => elt.isChecked).length} / ${element.sublist.length}",
              ),
            ),
          )
        ],
      ),
    );
  }
}