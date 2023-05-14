import 'package:flutter/material.dart';
import 'package:shop_app/utilities/constants.dart';
import 'package:google_fonts/google_fonts.dart';

class PrimaryMainButton extends StatelessWidget {

  PrimaryMainButton({
    required this.buttonColor,
    required this.buttonText,
    required this.textColor,
    required this.onPressed,
    required this.horizontalValue,
    required this.verticalValue,
    required this.isVisible,
  });

  final Color buttonColor;
  final String buttonText;
  final Color textColor;
  final Function onPressed;
  final double horizontalValue;
  final double verticalValue;
  final bool isVisible;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalValue, vertical: verticalValue),
      child: GestureDetector(
        onTap: (){
          onPressed();
        },
        child: Visibility(
          visible: isVisible,
          child: Container(
            decoration: BoxDecoration(
                color: buttonColor,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  )
                ]
            ),
            width: double.infinity,
            height: 48.0,
            child: Center(child: Text(buttonText, style: GoogleFonts.lato(
                color: textColor,
                fontSize: 16.0,
                fontWeight: FontWeight.w600
            ),)),
          ),
        ),
      ),
    );
  }
}