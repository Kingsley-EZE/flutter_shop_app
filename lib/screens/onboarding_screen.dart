import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shop_app/utilities/constants.dart';
import 'package:shop_app/components/primary_button.dart';
import 'registration_screen.dart';
import 'login_screen.dart';


class OnboardingScreen extends StatelessWidget {

  static const String id = 'onboarding_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFFF2F2F2),
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Hey! Welcome',
            style: GoogleFonts.poppins(
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
              color: Colors.black
            ),),
            Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 25.0),
              child: Text(
                  'We deliver on-demand quality goods directly \nfrom your nearby vendor',
                style: GoogleFonts.lato(
                  fontSize: 16.0,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            PrimaryMainButton(
                buttonColor: kPrimaryBrandColor,
                buttonText: 'Sign in',
                textColor: Colors.white,
                onPressed: (){
                  Navigator.pushNamed(context, LoginScreen.id);
                },
              horizontalValue: 16.0,
              verticalValue: 8.0,
            ),
            PrimaryMainButton(
              buttonColor: Colors.white,
              buttonText: 'Sign up',
              textColor: kPrimaryBrandColor,
              onPressed: (){
                Navigator.pushNamed(context, RegistrationScreen.id);
              },
              horizontalValue: 16.0,
              verticalValue: 8.0,
            ),
          ],
        ),
      ),
    );
  }
}


