import 'package:flutter/material.dart';
import 'package:shop_app/utilities/constants.dart';


class PrimaryInputField extends StatelessWidget {

  PrimaryInputField({
    required this.labelText,
    required this.onChanged,
    required this.hidePassword,
    required this.keyboard,
    required this.controller,
  });

  final String labelText;
  final ValueChanged<String> onChanged;
  final bool hidePassword;
  final TextInputType keyboard;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        obscureText: hidePassword,
        decoration: InputDecoration(
            labelText: labelText,
            hintStyle: TextStyle(color: kHintTextColor),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            focusColor: kPrimaryBrandColor,
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: kPrimaryBrandColor),
            )
        ),
        cursorColor: kPrimaryBrandColor,
        keyboardType: keyboard,
      ),
    );
  }
}
