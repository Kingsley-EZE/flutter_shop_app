import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class SoldProductsScreen extends StatefulWidget {
  const SoldProductsScreen({Key? key}) : super(key: key);

  static const String id = 'soldProducts_screen';

  @override
  State<SoldProductsScreen> createState() => _SoldProductsScreenState();
}

class _SoldProductsScreenState extends State<SoldProductsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Sold Products Screen', style: GoogleFonts.poppins(fontSize: 30.0, fontWeight: FontWeight.bold),),
      ),
    );
  }
}
