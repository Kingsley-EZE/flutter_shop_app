import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shop_app/model/user.dart';
import 'package:shop_app/utilities/constants.dart';
import 'package:shop_app/components/primary_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shop_app/utilities/image_helper.dart';
import 'home_screen.dart';

final imageHelper = ImageHelper();

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({Key? key}) : super(key: key);

  static const String id = 'complete_profile_screen';

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {

  final _auth = FirebaseAuth.instance;
  final _fireStore = FirebaseFirestore.instance;
  final _firebaseStorage = FirebaseStorage.instance;
  late String fullName;
  late String email;
  late String password;
  late String phoneNumber;
  String userInitials = '';
  bool showSpinner = false;
  File? _image;
  String userImageUrl = '';

  final TextEditingController _textController1 = TextEditingController();
  final TextEditingController _textController2 = TextEditingController();

  void showSnackBar(String message, Color backgroundColor){
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void getUserData() async{
    setState(() {
      showSpinner = true;
    });
    final docRef = _fireStore.collection(kUsers).doc(_auth.currentUser?.uid);
    await docRef.get().then(
            (DocumentSnapshot doc) {
              final data = doc.data() as Map<String, dynamic>;
              _textController1.text = data['fullName'];
              _textController2.text = data['email'];
              password = data['password'];
              userInitials = _textController1.text.characters.characterAt(0).toString();

              setState(() {
                showSpinner = false;
              });
            },
            onError: (e) {
              setState(() {
                showSpinner = false;
              });
              showSnackBar('$e', Colors.redAccent);
            },
            );
  }

  void updateUserInfo(String fullName, String email, String password, String? userId, String userProfileImage, int phoneNumber, int profileCompleted,) async{

     final docRef = _fireStore.collection(kUsers).doc(_auth.currentUser?.uid);

     final userInfo = UserModel(
         fullName: fullName,
         email: email,
         password: password,
         userId: userId,
         userProfileImage: userProfileImage,
         phoneNumber: phoneNumber,
         profileCompleted: profileCompleted);

     await docRef.update(userInfo.toMap()).then((value) {

     },
     onError: (e) {

     }
     );
  }

  uploadImageToCloudStorage(File? file, String fullName, String email, String password, String? userId, int phoneNumber, int profileCompleted,) async{
    setState(() {
      showSpinner = true;
    });
    try{
      if(file != null){
        var fileName = file.path.split('/').last;
        var firebaseStorageRef = _firebaseStorage.ref().child('uploads/$fileName');

        var task = await firebaseStorageRef.putFile(File(file.path));

        var downloadUrl = await task.ref.getDownloadURL();

        userImageUrl =  downloadUrl.toString();
        updateUserInfo(
            fullName,
            email,
            password,
            userId,
            userImageUrl,
            phoneNumber,
            1);
        setState(() {
          showSpinner = false;
        });
        showSnackBar('Updated Successfully', Colors.green);
        Navigator.pushNamed(context, HomeScreen.id);
      }
    }catch(e){
      setState(() {
        showSpinner = false;
      });
      showSnackBar('$e', Colors.redAccent);
    }

  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _textController1.dispose();
    _textController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhitishColor,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
            child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Container(
                          width: double.infinity,
                          child: Text(
                            'Complete Your Profile',
                            style: GoogleFonts.poppins(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w600
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),

                      GestureDetector(
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: CircleAvatar(
                            radius: 80,
                            backgroundColor: Colors.grey[300],
                            foregroundImage: _image != null ? FileImage(_image!) : null,
                            child: Text(
                                userInitials,
                            style: GoogleFonts.poppins(
                              color: kPrimaryBrandColor,
                              fontSize: 48.0,
                            ),),
                            ),
                          ),
                        onTap: () async{
                          try{
                            final chosenImage = await imageHelper.pickImage();
                            if(chosenImage != null){
                              File? img = File(chosenImage.path);
                              img = await imageHelper.cropImage(file: img);
                              setState(() {
                                _image = img;
                              });
                            }
                          }catch(e) {
                            print(e);
                          }
                        },
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, bottom: 30.0),
                        child: Text(
                            'Tap to choose image',
                            style: GoogleFonts.lato(
                              fontWeight: FontWeight.w600,
                              fontSize: 14.0,
                              color: Colors.black54
                            ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextField(
                          controller: _textController1,
                          enabled: false,
                          onChanged: (value){

                          },
                          decoration: InputDecoration(
                            labelText: 'Full name',
                              hintStyle: TextStyle(color: kHintTextColor),
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              focusColor: kPrimaryBrandColor,
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: kPrimaryBrandColor),
                              )
                          ),
                          cursorColor: kPrimaryBrandColor,
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextField(
                          controller: _textController2,
                          enabled: false,
                          onChanged: (value){

                          },
                          decoration: InputDecoration(
                              labelText: 'Email',
                              hintStyle: TextStyle(color: kHintTextColor),
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              focusColor: kPrimaryBrandColor,
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: kPrimaryBrandColor),
                              )
                          ),
                          cursorColor: kPrimaryBrandColor,
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextField(
                          onChanged: (value){
                            phoneNumber = value;
                          },
                          decoration: InputDecoration(
                              labelText: 'Phone number',
                              hintStyle: TextStyle(color: kHintTextColor),
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              focusColor: kPrimaryBrandColor,
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: kPrimaryBrandColor),
                              )
                          ),
                          cursorColor: kPrimaryBrandColor,
                        ),
                      ),

                      PrimaryMainButton(
                        buttonColor: kPrimaryBrandColor,
                        buttonText: 'Save',
                        textColor: Colors.white,
                        onPressed: () async{
                          // Update user info

                          fullName = _textController1.text;
                          email = _textController2.text;
                          uploadImageToCloudStorage(
                              _image,
                            fullName,
                            email,
                            password,
                            _auth.currentUser?.uid,
                            int.parse(phoneNumber),
                            1
                          );

                        },
                        horizontalValue: 0,
                        verticalValue: 40.0,
                      ),

                    ],
                  ),
                ),
            ),
        ),
      ),
    );
  }
}
