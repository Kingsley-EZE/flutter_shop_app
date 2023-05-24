import 'package:flutter/material.dart';
import 'package:shop_app/utilities/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shop_app/components/MainInputField.dart';
import 'package:shop_app/components/primary_button.dart';
import 'complete_profile_signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static const String id = 'login_screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _auth = FirebaseAuth.instance;
  final _fireStore = FirebaseFirestore.instance;
  String email = '';
  String password = '';
  String fullName = '';
  int userProfileCompleted = 0;
  bool showSpinner = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void showSnackBar(String message, Color backgroundColor){
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  bool validateUserInput(String email, String password){

    if(email == ''){
      showSnackBar('Email cannot be empty', Colors.redAccent);
      return false;
    }else if(password == ''){
      showSnackBar('Password cannot be empty', Colors.redAccent);
      return false;
    }

    return true;
  }

  void getUserData(UserCredential user) async{

    final docRef = _fireStore.collection(kUsers).doc(_auth.currentUser?.uid);
    await docRef.get().then(
          (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        userProfileCompleted = data['profileCompleted'];
        fullName = data['fullName'];
        if(user.user != null && userProfileCompleted == 0){
          Navigator.pushNamed(context, CompleteProfileScreen.id);
        }else if(user.user != null && userProfileCompleted == 1){
          Navigator.pushNamed(context, HomeScreen.id);
        }
        print('USER-PROFILE-COMPLETED: $userProfileCompleted');
      },
      onError: (e) {
            print(e);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: kWhitishColor,
          body: ModalProgressHUD(
            inAsyncCall: showSpinner,
            progressIndicator: const CircularProgressIndicator(color: kPrimaryBrandColor,),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: const BoxDecoration(
                            color: kBackButtonBgColor,
                            shape: BoxShape.circle
                        ),
                        child: const CircleAvatar(
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
                          'Sign In',
                          style: GoogleFonts.poppins(
                              fontSize: 30.0,
                              fontWeight: FontWeight.w600
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),


                    PrimaryInputField(
                      controller: _emailController,
                      labelText: 'Email',
                      onChanged: (value){
                        email = value;
                      },
                      hidePassword: false,
                      keyboard: TextInputType.emailAddress,
                    ),

                    PrimaryInputField(
                      controller: _passwordController,
                      labelText: 'Password',
                      onChanged: (value){
                        password = value;
                      },
                      hidePassword: true,
                      keyboard: TextInputType.text,
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 18.0),
                      child: GestureDetector(
                        onTap: (){
                          //Go to forgot password screen
                        },
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 22.0),
                          child: Text(
                            'Forgot Password?',
                            style: GoogleFonts.lato(
                              color: kRedTextColor,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ),
                    ),

                    PrimaryMainButton(
                      buttonColor: kPrimaryBrandColor,
                      buttonText: 'Sign in',
                      textColor: Colors.white,
                      onPressed: () async{
                        // login user
                        if(validateUserInput(email, password)){

                          setState(() {
                            showSpinner = true;
                          });

                          try{
                            final user = await _auth.signInWithEmailAndPassword(email: email, password: password);
                            getUserData(user);

                            setState(() {
                              showSpinner = false;
                            });
                          }catch(e) {
                            showSnackBar('Something went wrong', Colors.redAccent);
                            setState(() {
                              showSpinner = false;
                            });
                          }
                        }
                      },
                      horizontalValue: 0,
                      verticalValue: 40.0,
                      isVisible: true,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Don\'t have an account?',
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
            ),
          )
      ),
    );
  }
}