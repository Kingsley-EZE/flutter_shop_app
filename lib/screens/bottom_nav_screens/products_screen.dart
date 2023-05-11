import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class ProductsScreen extends StatefulWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  static const String id = 'products_screen';

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Products Screen', style: GoogleFonts.poppins(fontSize: 30.0, fontWeight: FontWeight.bold),),
      ),
    );
  }
}
