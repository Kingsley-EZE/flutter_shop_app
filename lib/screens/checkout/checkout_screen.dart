import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../firestore_class.dart';
import '../../utilities/constants.dart';

final _fireStore = FirebaseFirestore.instance;
FireStore mFireStore = FireStore();

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({
    required this.name,
    required this.phoneNumber,
    required this.address,
    required this.city,
    required this.additionalNote,
    required this.userId,
    Key? key
  }) : super(key: key);

  final String name;
  final String phoneNumber;
  final String address;
  final String city;
  final String additionalNote;
  final String userId;

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Checkout',
          style: GoogleFonts.poppins(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),),
        backgroundColor: kPrimaryBrandColor,
      ),
      body: CartListStream(
        name: widget.name,
        phoneNumber: widget.phoneNumber,
        address: widget.address,
        city: widget.city,
        additionalNote: widget.additionalNote,
      ),
    );
  }
}

class CartListStream extends StatelessWidget {
   CartListStream({
    this.deliveryFee = 0.0,
    this.totalAmt = 0.0,
    this.name = '',
    this.phoneNumber = '',
    this.address = '',
    this.city = '',
    this.additionalNote = '',
    Key? key
  }) : super(key: key);

  double deliveryFee;
  double totalAmt;
  String name;
  String phoneNumber;
  String address;
  String city;
  String additionalNote;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _fireStore.collection(kCarts).where(kUserId, isEqualTo: mFireStore.getCurrentUserId()).snapshots(),
        builder: (BuildContext context, snapshot){

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

          final cartItems = snapshot.data!.docs;

          if (cartItems.isEmpty) {
            return Center(
              child: Text(
                'Nothing in cart yet',
                style: GoogleFonts.lato(
                  fontSize: 20.0,
                  color: Colors.black54,
                ),
              ),
            );
          }

          double subTotal = 0.0;
          List<CartItemWidget> cartItemList = [];
          for(var cartItem in cartItems){
            final productImageUrl = cartItem.get('productImageUrl');
            final productName = cartItem.get('productName');
            final productPrice = cartItem.get('productPrice');
            final productCartQuantity = cartItem.get('productCartQuantity');
            final productStockQuantity = cartItem.get('productStockQuantity');

            final cart = CartItemWidget(
              productImageUrl: productImageUrl,
              productName: productName,
              productPrice: productPrice,
              productCartQuantity: productCartQuantity,
            );

            cartItemList.add(cart);

            if(int.parse(productCartQuantity) > 0){
              deliveryFee = 10.0;
            }else{
              deliveryFee = 0.0;
              totalAmt = 0.0;
            }

            if(int.parse(productStockQuantity) > 0){
              final price = double.parse(productPrice);
              final cartQuantity = double.parse(productCartQuantity);
              subTotal += (price * cartQuantity);
            }

          }

          if(subTotal > 0){
            totalAmt = subTotal + deliveryFee;
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: ListView(children: cartItemList,)),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                child: Text(
                  'Selected Address',
                   style: GoogleFonts.lato(
                     fontSize: 18.0,
                     fontWeight: FontWeight.w700,
                     color: kPrimaryBrandColor
                   ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 7.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7.0),
                  color: Colors.grey.shade200,
                ),
                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                        Text(
                        name,
                        style: GoogleFonts.lato(
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                        fontSize: 20.0
                        ),
                        ),
                const SizedBox(height: 10.0,),
                Text(
                address,
                style: GoogleFonts.lato(
                fontWeight: FontWeight.w500,
                color: Colors.black45,
                fontSize: 16.0
                ),
                ),
                const SizedBox(height: 10.0,),
                Text(
                phoneNumber,
                style: GoogleFonts.lato(
                fontWeight: FontWeight.w500,
                color: Colors.black45,
                fontSize: 16.0
                ),
                ),

                    const SizedBox(height: 10.0,),
                    Text(
                      additionalNote,
                      style: GoogleFonts.lato(
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                          fontSize: 18.0
                      ),
                    ),

                ],
                )
                ),
          ),

              Container(
                width: double.infinity,

                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                child: Column(
                  children: [

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Delivery Fee:',
                          style: GoogleFonts.lato(
                              fontSize: 16.0,
                              color: Colors.black54,
                              fontWeight: FontWeight.w800
                          ),
                        ),
                        Text(
                          '\$$deliveryFee',
                          style: GoogleFonts.lato(
                              fontSize: 18.0,
                              color: Colors.black54,
                              fontWeight: FontWeight.w800
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 10.0,),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total:',
                          style: GoogleFonts.lato(
                              fontSize: 22.0,
                              color: Colors.black54,
                              fontWeight: FontWeight.w800
                          ),
                        ),
                        Text(
                          '$totalAmt',
                          style: GoogleFonts.lato(
                              fontSize: 20.0,
                              color: Colors.black87,
                              fontWeight: FontWeight.w800
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 30.0,),

                    GestureDetector(
                      onTap: (){

                      },
                      child: Container(
                        width: double.infinity,
                        height: 48.0,
                        decoration: BoxDecoration(
                            color: kPrimaryBrandColor,
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 5,
                                offset: Offset(0, 2),
                              )
                            ]
                        ),
                        child: Center(
                          child: Text(
                            'Place Order',
                            style: GoogleFonts.lato(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600
                            ),
                          ),
                        ),
                      ),
                    )

                  ],
                ),
              )
            ],
          );

        }
    );
  }
}


class CartItemWidget extends StatelessWidget {
  const CartItemWidget({
    required this.productImageUrl,
    required this.productName,
    required this.productPrice,
    required this.productCartQuantity,
    Key? key
  }) : super(key: key);

  final String productImageUrl;
  final String productName;
  final String productPrice;
  final String productCartQuantity;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: Container(
        padding: const EdgeInsets.all(10.0),
        width: double.infinity,
        height: 145.0,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(

          children: [

            Container(
              width: 130.0,
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10.0),
                  image: DecorationImage(
                      image: NetworkImage(productImageUrl),
                      fit: BoxFit.cover
                  )
              ),
            ),

            SizedBox(width: 10.0,),

            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productName,
                  style: GoogleFonts.lato(fontWeight: FontWeight.w700, color: Colors.black87, fontSize: 18.0),
                ),

                const SizedBox(width: 30.0,),

                Text(productCartQuantity, style: GoogleFonts.lato(fontWeight: FontWeight.w700, color: Colors.black87, fontSize: 16.0),),

                const SizedBox(width: 30.0,),

                Text(
                  'NGN$productPrice',
                  style: GoogleFonts.lato(fontWeight: FontWeight.w800, color: Colors.black87, fontSize: 16.0),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}


