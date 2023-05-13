import 'package:flutter/material.dart';
import 'package:shop_app/utilities/constants.dart';

class OutlinedInputField extends StatelessWidget {

  OutlinedInputField({
    required this.labelText,
    required this.onChanged,
    required this.keyboard,
    required this.maxLines,
  });

  final String labelText;
  final ValueChanged<String> onChanged;
  final TextInputType keyboard;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: labelText,
          hintStyle: TextStyle(color: kHintTextColor),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          focusColor: kPrimaryBrandColor,
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
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