import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shop_app/screens/add_products.dart';
import 'package:shop_app/utilities/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:shop_app/screens/products/product_details_screen.dart';
import 'package:shop_app/utilities/slide_from_bottom_anim.dart';

final _auth = FirebaseAuth.instance;
final _fireStore = FirebaseFirestore.instance;

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  static const String id = 'products_screen';

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {

  late bool _isLoading;

  @override
  void initState() {
    _isLoading = true;
    Future.delayed(const Duration(seconds: 2), (){
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _isLoading ?
            Expanded(
                child: ListView.separated(itemBuilder: (context, index) => NewSkeletonCard(),
                    separatorBuilder: (context, index) => SizedBox(height: 5,),
                    itemCount: 6)
            )
                :
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

          /*if(snapshot.connectionState == ConnectionState.waiting){
            return Center(child: Text(
              'Loading',
                style: GoogleFonts.lato(
                    fontSize: 20.0,
                    color: Colors.black54),
            ),
            );
          }*/

          final productItems = snapshot.data!.docs;
          if (productItems.isEmpty) {
            return Center(
              child: Text(
                'You have no products yet',
                style: GoogleFonts.lato(
                  fontSize: 20.0,
                  color: Colors.black54,
                ),
              ),
            );
          }


          List<UserProductItem> userProductItem = [];

          for(var productItem in productItems){
            final productName = productItem.get('productName');
            final productPrice = productItem.get('productPrice');
            final productImageUrl = productItem.get('productImageUrl');
            final productId = productItem.id;
            final productOwnerId = productItem.get('userId');
            final productDescription = productItem.get('productDescription');
            final productQuantity = productItem.get('productQuantity');

            final product = UserProductItem(
                productName: productName,
                productPrice: productPrice,
                productImageUrl: productImageUrl,
                productId: productId,
                productOwnerId: productOwnerId,
                productDescription: productDescription,
                productQuantity: productQuantity,
                );

            userProductItem.add(product);
          }

          return Expanded(
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
    required this.productId,
    required this.productOwnerId,
    required this.productDescription,
    required this.productQuantity
});

  final String productName;
  final String productPrice;
  final String productId;
  final String productOwnerId;
  final String? productImageUrl;
  final String? productDescription;
  final String? productQuantity;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: (){
          Navigator.push(
            context,
            SlideFromBottomPageRoute(
              child: ProductDetailsScreen(productName: productName, productPrice: productPrice, productImageUrl: productImageUrl, productId: productId, productOwnerId: productOwnerId, productDescription: productDescription, productQuantity: productQuantity),
              durationMs: 500,
            ),
          );
        },
      child: Container(
        width: double.infinity,
        height: 120,
        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
        child: Row(
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
                      fit: BoxFit.contain
                    )
                  ),
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
                    productPrice,
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
      ),
    );
  }
}

class NewSkeletonCard extends StatelessWidget {
  const NewSkeletonCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
      child: Row(
        children: [
          Skelton(
            height: 120,
            width: 120,
          ),
          SizedBox(width: 10,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Skelton(height: 25, width: 200),
                SizedBox(height: 35,),
                Skelton(height: 25, width: 200)
              ],
            ),
          )
        ],
      ),
    );
  }
}

class Skelton extends StatelessWidget {
  Skelton({
    required this.height,
    required this.width,
  });

  final double height, width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.04),
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    );
  }
}