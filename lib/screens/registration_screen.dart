import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shop_app/utilities/constants.dart';
import 'package:shop_app/components/MainInputField.dart';
import 'package:shop_app/components/primary_button.dart';
import 'package:shop_app/model/user.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shop_app/components/navigate_back_arrow.dart';


class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  static const String id = 'registration_screen';

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {

  final _auth = FirebaseAuth.instance;
  final _fireStore = FirebaseFirestore.instance;
  late UserModel userInfo;
  String fullName = '';
  String email = '';
  String password = '';
  String confirmPassword = '';
  bool showSpinner = false;

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void showSnackBar(String message, Color backgroundColor){
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  bool validateUserInput(String fullName, String email, String password, String confirmPassword){

    if(fullName == ''){
      showSnackBar('Full name cannot be empty', Colors.redAccent);
      return false;
    }else if(email == ''){
      showSnackBar('Email cannot be empty', Colors.redAccent);
      return false;
    }else if(password == ''){
      showSnackBar('Password cannot be empty', Colors.redAccent);
      return false;
    }else if(confirmPassword != password){
      showSnackBar('Password and Confirm Password don\'t match', Colors.redAccent);
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kWhitishColor,
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          progressIndicator: CircularProgressIndicator(color: kPrimaryBrandColor,),
          child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BackArrowWidget(),

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
                      controller: _fullNameController,
                      labelText: 'Full name',
                      onChanged: (value){
                        //Get fullName
                        fullName = value;
                      },
                      hidePassword: false,
                      keyboard: TextInputType.name,
                    ),

                    PrimaryInputField(
                      controller: _emailController,
                      labelText: 'Email',
                      onChanged: (value){
                        //Get Email
                        email = value;
                      },
                      hidePassword: false,
                      keyboard: TextInputType.emailAddress,
                    ),

                    PrimaryInputField(
                      controller: _passwordController,
                      labelText: 'Password',
                      onChanged: (value){
                        //Get password
                        password = value;
                      },
                      hidePassword: true,
                      keyboard: TextInputType.text,
                    ),

                    PrimaryInputField(
                      controller: _confirmPasswordController,
                      labelText: 'Confirm Password',
                      onChanged: (value){
                        confirmPassword = value;
                      },
                      hidePassword: true,
                      keyboard: TextInputType.text,
                    ),

                    PrimaryMainButton(
                      buttonColor: kPrimaryBrandColor,
                      buttonText: 'Sign Up',
                      textColor: Colors.white,
                      onPressed: () async{
                        // Register user

                        if(validateUserInput(fullName, email, password, confirmPassword)){

                          setState(() {
                            showSpinner = true;
                          });

                          try {
                            await _auth.createUserWithEmailAndPassword(
                              email: email,
                              password: password,
                            );

                            userInfo = UserModel(
                                fullName: fullName,
                                email: email,
                                password: password,
                                userId: _auth.currentUser?.uid,
                                userProfileImage: '',
                                phoneNumber: 0,
                                profileCompleted: 0
                            );

                            final userCollection = _fireStore.collection(kUsers).doc(_auth.currentUser?.uid);
                            await userCollection.set(userInfo.toMap());

                            setState(() {
                              showSpinner = false;
                              showSnackBar('Account created successfully', Colors.green);
                            });

                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'weak-password') {
                              showSnackBar('Your password is weak', Colors.red);
                            } else if (e.code == 'email-already-in-use') {
                              showSnackBar('Email is already in use', Colors.redAccent);
                            }
                            setState(() {
                              showSpinner = false;
                            });
                          } catch (e) {
                            setState(() {
                              showSpinner = false;
                            });
                            print(e);
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
          ),
        )
      ),
    );
  }
}

/*
if(fullName.isEmpty){
      showSnackBar('Full name cannot be empty', Colors.redAccent);
      return false;
    }else if(email.isEmpty){
      showSnackBar('Email cannot be empty', Colors.redAccent);
      return false;
    }else if(password.isEmpty){
      showSnackBar('Password cannot be empty', Colors.redAccent);
      return false;
    }else if(confirmPassword != password){
      showSnackBar('password and confirm password don\'t match', Colors.redAccent);
      return false;
    }else{
      return true;
    }
*/