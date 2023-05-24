import 'package:flutter/material.dart';
import 'package:shop_app/utilities/constants.dart';

class OutlinedInputField extends StatelessWidget {

  OutlinedInputField({
    required this.labelText,
    required this.onChanged,
    required this.keyboard,
    required this.maxLines,
    required this.controller,
  });

  final String labelText;
  final ValueChanged<String> onChanged;
  final TextInputType keyboard;
  final int maxLines;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: labelText,
          hintStyle: const TextStyle(color: kHintTextColor),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          focusColor: kPrimaryBrandColor,
          border: const OutlineInputBorder(),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: kPrimaryBrandColor),
          ),
        ),
        cursorColor: kPrimaryBrandColor,
        maxLines: maxLines,
        keyboardType: keyboard,
      ),
    );
  }
}