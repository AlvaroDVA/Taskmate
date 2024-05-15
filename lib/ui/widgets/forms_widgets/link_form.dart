import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';

import '../../../config/app_config.dart';

class LinkForm extends StatelessWidget {

  final String textNotLink;

  final String textLink;
  final VoidCallback onTap;

  const LinkForm({
    super.key,
    required this.textNotLink,
    required this.textLink,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    AppConfig appConfig = Provider.of<AppConfig>(context);

    return RichText(
      text: TextSpan(
        style: DefaultTextStyle.of(context).style,
        children: <TextSpan>[
          TextSpan(
            text: textNotLink,
            style: TextStyle(color: appConfig.theme.darkAuxColor),
          ),
          TextSpan(
              text:textLink,
              style: TextStyle(
                color: appConfig.theme.primaryColor,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = onTap
          ),
        ],
      ),
    );
  }
}