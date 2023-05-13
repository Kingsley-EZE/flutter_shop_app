import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shop_app/screens/add_products.dart';
import 'package:shop_app/utilities/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:html_character_entities/html_character_entities.dart';
import 'package:intl/intl.dart';
import 'dart:io';

final _auth = FirebaseAuth.instance;
final _fireStore = FirebaseFirestore.instance;

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  static const String id = 'products_screen';

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {

  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            UserProductStream(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPrimaryBrandColor,
          onPressed: (){
            Navigator.pushNamed(context, AddProductsScreen.id);
          },
          child: Icon(Icons.add),
      ),
    );
  }
}

class UserProductStream extends StatelessWidget {
  const UserProductStream({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _fireStore.collection(kProducts).where(kUserId, isEqualTo: _auth.currentUser?.uid).snapshots(),
        builder: (BuildContext context, snapshot){
          if(!snapshot.hasData){
            return Center(
              child: Text(
                'You have no products yet',
                style: GoogleFonts.lato(
                    fontSize: 20.0,
                    color: Colors.black54),
              ),
              );
          }

          if(snapshot.hasError){
            return Center(
              child: Text(
                'Something went wrong',
                style: GoogleFonts.lato(
                    fontSize: 20.0,
                    color: Colors.black54),
              ),
            );
          }

          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(child: Text(
              'Loading',
                style: GoogleFonts.lato(
                    fontSize: 20.0,
                    color: Colors.black54),
            ),
            );
          }

          final productItems = snapshot.data!.docs;
          List<UserProductItem> userProductItem = [];
          for(var productItem in productItems){
            final productName = productItem.get('productName');
            final productPrice = productItem.get('productPrice');
            final productImageUrl = productItem.get('productImageUrl');

            final product = UserProductItem(productName: productName, productPrice: productPrice, productImageUrl: productImageUrl);
            userProductItem.add(product);
          }
          return Flexible(
              child: ListView(
                children: userProductItem,
              ));
        }
    );
  }
}


class UserProductItem extends StatelessWidget {
  UserProductItem({
    required this.productName,
    required this.productPrice,
    required this.productImageUrl,
});

  final String productName;
  final String productPrice;
  final String? productImageUrl;

  String currency(){
    var format = NumberFormat.simpleCurrency(locale: Platform.localeName, name: 'USD');
    return format.currencySymbol;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 120,
      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
      child: Row(
        children: [

          Stack(
            children: [
              Container(
                width: 115.0,
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    color: Colors.grey.shade400,
                    width: 2.0,
                  ),
                  image: DecorationImage(
                    image: NetworkImage(productImageUrl!),
                    fit: BoxFit.cover
                  )
                ),
              ),
            ],
          ),


          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productName,
                  style: GoogleFonts.lato(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 20.0
                  ),
                ),

                Text(
                  '${currency()}$productPrice',
                  style: GoogleFonts.lato(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 20.0
                  ),
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }
}