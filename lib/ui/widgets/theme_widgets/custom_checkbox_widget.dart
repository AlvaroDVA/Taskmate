import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../config/app_config.dart';
import '../../../services/service_locator.dart';

class CustomCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;

  CustomCheckbox({
    required this.value,
    required this.onChanged,
  });

  final AppConfig appConfig = ServiceLocator.appConfig;

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      fillColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
        if (states.contains(MaterialState.selected)) {
          return appConfig.theme.lightColor2;
        }
        return appConfig.theme.greyColor;
      }),
      checkColor: appConfig.theme.darkAuxColor,
      value: value,
      onChanged: onChanged,
    );
  }
}