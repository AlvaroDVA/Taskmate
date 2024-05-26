import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class TextBlockForm extends StatelessWidget {
  const TextBlockForm({
    super.key,
    required this.textEditingController,
    required this.text,
    required this.isHiddenText,
  });

  final TextEditingController textEditingController;
  final String text;
  final bool isHiddenText;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      child: TextField(
        controller: textEditingController,
        decoration: InputDecoration(
          labelText: text,
        ),
        obscureText: isHiddenText,
      ),
    );
  }
}



