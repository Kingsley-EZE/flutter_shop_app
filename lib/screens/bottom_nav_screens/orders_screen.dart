import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  static const String id = 'orders_screen';

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Orders Screen', style: GoogleFonts.poppins(fontSize: 30.0, fontWeight: FontWeight.bold),),
      ),
    );
  }
}
