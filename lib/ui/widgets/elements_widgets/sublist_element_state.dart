import 'dart:async';

import 'package:flutter/material.dart';
import 'package:taskmate_app/states/tasks_loaded_state.dart';

import '../../../config/app_config.dart';
import '../../../models/elementTasks/sublist.dart';
import '../../../models/elementTasks/sublist_element.dart';
import '../../../services/service_locator.dart';
import '../element_task_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../theme_widgets/custom_checkbox_widget.dart';

class SublistElementState extends State<ElementTaskWidget> {
  final SublistElement element;
  late final AppConfig appConfig;
  late List<TextEditingController> _sublistControllers;
  late List<Timer?> _debounceTimers = List.empty(growable: true);
  Timer? _debounceTimer;

  TasksLoadedState tasksLoadedState = ServiceLocator.taskLoadedState;


  SublistElementState({
    required this.element,
  }) {
    appConfig = ServiceLocator.appConfig;
    _sublistControllers = element.sublist.map((subElement) {
      return TextEditingController(text: subElement.text);
    }).toList();
  }

  @override
  void initState() {
    _debounceTimers = List<Timer?>.filled(element.sublist.length, null, growable: true);
    super.initState();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double _padding = 10.0;

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
                        _debounceTimers.add(null);
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
          color: appConfig.theme.sublistColor,
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
          height: (72.0 * element.sublist.length),
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
                        onChanged: (newText) => _onTextChanged(newText, index),
                        style: appConfig.theme.text,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: AppLocalizations.of(context)!.sublistHint,
                          hintStyle: appConfig.theme.text,
                          icon: IconButton(
                            icon : Icon(Icons.delete),
                            color: appConfig.theme.iconColor,
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
                    CustomCheckbox(
                      value: element.sublist[index].isChecked,
                      onChanged: (_) {
                        setState(() {
                          element.sublist[index].isChecked = !element.sublist[index].isChecked;
                        });
                      },
                    )
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
              onChanged: _onTitleChanged,
              style: appConfig.theme.title,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.sublistHint,
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

  void _onTextChanged(String newText, int index) {
    if (_debounceTimers[index]?.isActive ?? false) _debounceTimers[index]?.cancel();
    _debounceTimers[index] = Timer(Duration(milliseconds: 500), () {
      setState(() {
        element.sublist[index].text = newText;
      });
    });

  }

  void _onTitleChanged(String newText) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer?.cancel();
    _debounceTimer = Timer(Duration(milliseconds: 500), () {
      element.title = newText;
      tasksLoadedState.saveCurrentTask();
    });
  }
}