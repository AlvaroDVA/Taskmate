import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FormSubmitButton extends StatelessWidget {

  final String textButton;
  final VoidCallback? onPressed;

  const FormSubmitButton({
    super.key,
    required this.textButton,
    this.onPressed,
  });



  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        child: Text(textButton)
    );
  }

}