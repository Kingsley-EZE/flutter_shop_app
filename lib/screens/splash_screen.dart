import 'package:flutter/material.dart';
import 'package:shop_app/utilities/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'onboarding_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_screen.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  static const String id = 'splash_screen';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () async{
      checkLoggedInState();
    });
  }

  void checkLoggedInState(){
    var user =  _auth.currentUser;
    if(user != null){
      Navigator.popAndPushNamed(context, HomeScreen.id);
    }else{
      Navigator.popAndPushNamed(context, OnboardingScreen.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryBrandColor,
      body: Center(
        child: Text(
          'Shoppa',
          style: GoogleFonts.poppins(
              fontSize: 35.0,
              fontWeight: FontWeight.w700,
              color: Colors.white
          ),
        ),
      ),
    );
  }
}
