import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shop_app/utilities/constants.dart';
import 'package:shop_app/components/MainInputField.dart';
import 'package:shop_app/components/primary_button.dart';


class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  static const String id = 'registration_screen';

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kWhitishColor,
        body: Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                          color: kBackButtonBgColor,
                          shape: BoxShape.circle
                      ),
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        child: Icon(Icons.arrow_back, color: Colors.black,),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Container(
                      width: double.infinity,
                      child: Text(
                          'Sign Up',
                        style: GoogleFonts.poppins(
                          fontSize: 30.0,
                          fontWeight: FontWeight.w600
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                  PrimaryInputField(
                    labelText: 'Full name',
                    onChanged: (value){
                      print(value);
                    },
                    hidePassword: false,
                    keyboard: TextInputType.name,
                  ),

                  PrimaryInputField(
                    labelText: 'Email',
                    onChanged: (value){
                      print(value);
                    },
                    hidePassword: false,
                    keyboard: TextInputType.emailAddress,
                  ),

                  PrimaryInputField(
                    labelText: 'Password',
                    onChanged: (value){
                      print(value);
                    },
                    hidePassword: true,
                    keyboard: TextInputType.text,
                  ),

                  PrimaryInputField(
                    labelText: 'Confirm Password',
                    onChanged: (value){
                      print(value);
                    },
                    hidePassword: true,
                    keyboard: TextInputType.text,
                  ),

                  PrimaryMainButton(
                    buttonColor: kPrimaryBrandColor,
                    buttonText: 'Sign Up',
                    textColor: Colors.white,
                    onPressed: (){
                      // Register user
                    },
                    horizontalValue: 0,
                    verticalValue: 40.0,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                          'Already have an account?',
                        style: GoogleFonts.lato(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500
                        ),
                      ),

                      SizedBox(width: 7.0),

                      GestureDetector(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: Text(
                            'Click here',
                            style: GoogleFonts.lato(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: kPrimaryBrandColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )

                ],
              ),
            ),
        )
      ),
    );
  }
}

