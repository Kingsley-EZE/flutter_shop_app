import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shop_app/utilities/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../firestore_class.dart';
import 'package:shop_app/tabs/user_order_tab.dart';
import 'package:shop_app/tabs/product_owner_tab.dart';

final _fireStore = FirebaseFirestore.instance;
FireStore mFireStore = FireStore();

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  static const String id = 'orders_screen';

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'My Orders',
            style: GoogleFonts.poppins(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),),
          backgroundColor: kPrimaryBrandColor,
        ),
         body: Column(
           children: [
             TabBar(tabs: [
               Tab(child: Text('My Orders', style: GoogleFonts.lato(color: kPrimaryBrandColor, fontWeight: FontWeight.w600),),),
               Tab(child: Text('Customer Orders', style: GoogleFonts.lato(color: kPrimaryBrandColor, fontWeight: FontWeight.w600),),),
             ],
             indicatorColor: kPrimaryBrandColor,),

             const Expanded(
               child: TabBarView(
                 children: [
                   OrderItemStream(),
                   OwnerOrderItemStream(),
                 ],
               ),
             ),

           ],

         ),
      ),
    );
  }
}
