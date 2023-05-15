import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shop_app/firestore_class.dart';
import 'package:shop_app/utilities/constants.dart';
import 'package:shop_app/utilities/slide_from_bottom_anim.dart';

import '../products/product_details_screen.dart';

final _auth = FirebaseAuth.instance;
final _fireStore = FirebaseFirestore.instance;

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  static const String id = 'dashboard_screen';

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 16.0),
        child: DashboardItemsStream(),
      ),
    );
  }
}


class DashboardItemsStream extends StatelessWidget {
  const DashboardItemsStream({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _fireStore.collection(kProducts).snapshots(),
        builder: (BuildContext context, snapshot){

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: Text("Loading"));
          }

          if(!snapshot.hasData){
            return Center(
              child: Text(
                'No available products',
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

          List<ProductItemWidget> productItemWidgetList = [];

          for(var productItem in productItems){
            final productName = productItem.get('productName');
            final productPrice = productItem.get('productPrice');
            final productImageUrl = productItem.get('productImageUrl');
            final productId = productItem.id;
            final productOwnerId = productItem.get('userId');
            final productDescription = productItem.get('productDescription');
            final productQuantity = productItem.get('productQuantity');

            final product = ProductItemWidget(
                productName: productName,
                productImageUrl: productImageUrl,
                productPrice: productPrice,
                productId: productId,
                productOwnerId: productOwnerId,
                productDescription: productDescription,
                productQuantity: productQuantity,
            );

            productItemWidgetList.add(product);
          }

          return GridView.builder(
              itemCount: productItems.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2 / 3,
                mainAxisSpacing: 15.0,
                crossAxisSpacing: 12.0,
              ),
              itemBuilder: (context, index){
                final productItem = productItemWidgetList[index];
                return ProductItemWidget(
                    productName: productItem.productName,
                    productImageUrl: productItem.productImageUrl,
                    productPrice: productItem.productPrice,
                    productId: productItem.productId,
                    productOwnerId: productItem.productOwnerId,
                    productDescription: productItem.productDescription,
                    productQuantity: productItem.productQuantity,
                );

              }
          );



        }
    );
  }
}


class ProductItemWidget extends StatelessWidget {
  const ProductItemWidget({
    Key? key,
    required this.productName,
    required this.productImageUrl,
    required this.productPrice,
    required this.productId,
    required this.productOwnerId,
    required this.productDescription,
    required this.productQuantity,
  }) : super(key: key);

  final String productName;
  final String productPrice;
  final String? productImageUrl;
  final String productId;
  final String productOwnerId;
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  image: DecorationImage(
                      image: NetworkImage(productImageUrl!),
                      fit: BoxFit.cover
                  ),
                ),
              )),
          SizedBox(height: 7,),
          Text(
            productName,
            style: GoogleFonts.lato(
              fontWeight: FontWeight.w800,
              color: Colors.black,
              fontSize: 20,
            ),
          ),
          SizedBox(height: 5,),

          Text(
            productPrice,
            style: GoogleFonts.lato(
              fontWeight: FontWeight.w800,
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

