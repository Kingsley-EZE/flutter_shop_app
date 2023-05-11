import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  static const String id = 'profile_screen';

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Profile Screen', style: GoogleFonts.poppins(fontSize: 30.0, fontWeight: FontWeight.bold),),
      ),
    );
  }
}
