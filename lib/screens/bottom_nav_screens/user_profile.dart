import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shop_app/screens/login_screen.dart';
import 'package:shop_app/utilities/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';


class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  static const String id = 'profile_screen';

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {

  final _auth = FirebaseAuth.instance;
  final _fireStore = FirebaseFirestore.instance;
  bool showSpinner = false;
  String fullName = '';
  String email = '';
  String imageUrl = '';
  String userInitials = '';

  void getUserData()async{
    setState(() {
      showSpinner = true;
    });
    final docRef = _fireStore.collection(kUsers).doc(_auth.currentUser?.uid);
    await docRef.get().then(
          (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        fullName = data['fullName'];
        email = data['email'];
        imageUrl = data['userProfileImage'];
        userInitials = fullName.characters.characterAt(0).toString();

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

  void showSnackBar(String message, Color backgroundColor){
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void logout()async{
    try{
      setState(() {
        showSpinner = true;
      });
      await _auth.signOut();
      setState(() {
        showSpinner = false;
      });
      Navigator.popAndPushNamed(context, LoginScreen.id);
    }catch(e){
      print(e);
      setState(() {
        showSpinner = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SafeArea(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                color: kPrimaryBrandColor,
                padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Profile',
                      style: GoogleFonts.lato(
                        fontSize: 27.0,
                        fontWeight: FontWeight.w700,
                        color: Colors.white
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 25.0),
                      child: Row(
                        children: [
                          Container(
                            width: 100.0,
                            height: 100.0,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: NetworkImage(imageUrl),
                              fit: BoxFit.cover),
                            ),
                          ),

                          const SizedBox(width: 10.0,),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(fullName, style: GoogleFonts.lato(fontWeight: FontWeight.w700, color: Colors.white, fontSize: 20.0),),
                              const SizedBox(height: 10.0,),
                              Text(email, style: GoogleFonts.lato(fontWeight: FontWeight.w700, color: Colors.white70, fontSize: 18.0),)
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              RowItemWidget(text: 'Edit Profile', onPressed: (){}, paddingTop: 30.0, icon: Icons.edit,),
              RowItemWidget(text: 'Settings', onPressed: (){}, paddingTop: 7.0, icon: Icons.settings,),
              RowItemWidget(text: 'Support', onPressed: (){}, paddingTop: 7.0, icon: Icons.support_agent,),
              RowItemWidget(text: 'Sign out', onPressed: (){ logout(); }, paddingTop: 7.0, icon: Icons.logout,),

            ],
          ),
        ),
      ),
    );
  }
}

class RowItemWidget extends StatelessWidget {
  const RowItemWidget({
    required this.text,
    required this.onPressed,
    required this.paddingTop,
    required this.icon,
    super.key,
  });

  final String text;
  final Function onPressed;
  final double paddingTop;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        onPressed();
      },
      child: Padding(
        padding:  EdgeInsets.only(left: 16.0, right: 16.0, top: paddingTop, bottom: 20.0),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(14.0),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 22.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, color: kPrimaryBrandColor,),
                  SizedBox(width: 16.0,),
                  Text(
                    text,
                    style: GoogleFonts.lato(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.black87,)
            ],
          ),
        ),
      ),
    );
  }
}
