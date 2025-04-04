// lib/custom_text_field.dart

import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  final String label;
  final bool isPassword;
  final TextInputType keyboardType;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;

  TextFieldWidget({
    required this.label,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onSaved, this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.blueAccent.withOpacity(0.5), // You can adjust the shade of blue here
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          borderSide: BorderSide.none,
        ),
      ),
      obscureText: isPassword,
      keyboardType: keyboardType,
      validator: validator,
      onSaved: onSaved,
    );
  }
}
