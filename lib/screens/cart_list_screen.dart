import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shop_app/model/cartItem.dart';
import 'package:shop_app/utilities/constants.dart';
import 'package:shop_app/utilities/dotted_divider.dart';
import 'package:shop_app/bottom_nav_icons_icons.dart';
import '../firestore_class.dart';

final _fireStore = FirebaseFirestore.instance;
FireStore mFireStore = FireStore();

class CartListScreen extends StatefulWidget {
  const CartListScreen({Key? key}) : super(key: key);

  static const String id = 'cart_list_screen';

  @override
  State<CartListScreen> createState() => _CartListScreenState();
}

class _CartListScreenState extends State<CartListScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: Text(
          'My Cart',
          style: GoogleFonts.poppins(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),),
        backgroundColor: kPrimaryBrandColor,
      ),
      body: CartListStream(),
    );
  }
}

/*
class CartListStream extends StatelessWidget {
  const CartListStream({Key? key}) : super(key: key);

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

          List<CartItemWidget> cartItemList = [];
          for(var cartItem in cartItems){
            final productImageUrl = cartItem.get('productImageUrl');
            final productName = cartItem.get('productName');
            final productPrice = cartItem.get('productPrice');
            final productCartQuantity = cartItem.get('productCartQuantity');
            final productStockQuantity = cartItem.get('productStockQuantity');
            final cartId = cartItem.id;

            final cart = CartItemWidget(
              productImageUrl: productImageUrl,
              productName: productName,
              productPrice: productPrice,
              updateCartItems: true,
              productCartQuantity: productCartQuantity,
              productStockQuantity: productStockQuantity,
              cartId: cartId,
            );

            cartItemList.add(cart);
          }

          return Expanded(child: ListView(children: cartItemList,));

        }
    );
  }
}
*/

class CartListStream extends StatefulWidget {
  const CartListStream({Key? key}) : super(key: key);

  @override
  State<CartListStream> createState() => _CartListStreamState();
}

class _CartListStreamState extends State<CartListStream> {

  double deliveryFee = 0.0;
  double totalAmt = 0.0;
  bool buttonEnabled = false;

  // @override
  // void initState() {
  //   super.initState();
  //   totalAmt = 0.0;
  // }

  void showSnackBar(String message, Color backgroundColor){
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

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
            final cartId = cartItem.id;

            final cart = CartItemWidget(
              productImageUrl: productImageUrl,
              productName: productName,
              productPrice: productPrice,
              updateCartItems: true,
              productCartQuantity: productCartQuantity,
              productStockQuantity: productStockQuantity,
              cartId: cartId,
            );

            cartItemList.add(cart);

            if(int.parse(productCartQuantity) > 0){
              deliveryFee = 10.0;
              buttonEnabled = true;
            }else{
              deliveryFee = 0.0;
              totalAmt = 0.0;
              buttonEnabled = false;
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
            children: [
              Expanded(child: ListView(children: cartItemList,)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 7.0),
                child: DottedDivider(
                  thickness: 3.0,
                  dashWidth: 7.0,
                  dashSpace: 4.0,
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
                      onTap: buttonEnabled ? (){

                      } : (){
                        showSnackBar('Minimum of one item to checkout', Colors.redAccent);
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
                            'Checkout',
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



class CartItemWidget extends StatefulWidget {
  CartItemWidget({
    required this.productImageUrl,
    required this.productName,
    required this.productPrice,
    required this.updateCartItems,
    required this.productCartQuantity,
    required this.productStockQuantity,
    required this.cartId
});

  String productImageUrl;
  String productName;
  String productPrice;
  bool updateCartItems;
  String productCartQuantity;
  String productStockQuantity;
  String cartId;

  @override
  State<CartItemWidget> createState() => _CartItemWidgetState();
}

class _CartItemWidgetState extends State<CartItemWidget> {

  bool isDeleteIconVisible = true;
  bool isMinusIconVisible = true;

  void showSnackBar(String message, Color backgroundColor){
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: Container(
        padding: EdgeInsets.all(10.0),
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
                      image: NetworkImage(widget.productImageUrl),
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
                  widget.productName,
                  style: GoogleFonts.lato(fontWeight: FontWeight.w700, color: Colors.black87, fontSize: 18.0),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(
                      color: Colors.grey.shade200,
                      width: 2.0,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                          onTap: ()async{
                            var cartQuantity = int.parse(widget.productCartQuantity);
                            if(cartQuantity == 0){
                              setState(() {
                                //isMinusIconVisible = false;
                                cartQuantity = 0;
                                isDeleteIconVisible = false;
                              });
                            }else{
                              //Suppose to show a progress dialog
                              var itemMap = <String, dynamic>{};
                              itemMap['productCartQuantity'] = (cartQuantity - 1).toString();

                              await _fireStore.collection(kCarts).doc(widget.cartId).update(itemMap);

                            }

                          },
                          child: Visibility(
                              visible: isMinusIconVisible,
                              child: const Icon(BottomNavIcons.minus, color: Colors.black87,)
                          )
                      ),

                      const SizedBox(width: 30.0,),

                      Text(widget.productCartQuantity, style: GoogleFonts.lato(fontWeight: FontWeight.w700, color: Colors.black87, fontSize: 16.0),),

                      const SizedBox(width: 30.0,),

                      GestureDetector(
                          onTap: ()async{
                            var cartQuantity = int.parse(widget.productCartQuantity);
                            if(cartQuantity < int.parse(widget.productStockQuantity)){
                              setState(() {
                                isMinusIconVisible = true;
                                isDeleteIconVisible = true;
                              });
                              //Suppose to show a progress dialog
                              var itemMap = <String, dynamic>{};
                              itemMap['productCartQuantity'] = (cartQuantity + 1).toString();

                              await _fireStore.collection(kCarts).doc(widget.cartId).update(itemMap);

                            }else{
                              showSnackBar('Maximum stock quantity is ${widget.productStockQuantity}', Colors.redAccent);
                            }

                          },
                          child: const Icon(Icons.add, color: Colors.black87,)
                      ),
                    ],
                  ),
                ),

                Text(
                  'NGN${widget.productPrice}',
                  style: GoogleFonts.lato(fontWeight: FontWeight.w800, color: Colors.black87, fontSize: 16.0),
                ),
              ],
            ),

            const Spacer(),

            GestureDetector(
              onTap: ()async{
                await _fireStore.collection(kCarts).doc(widget.cartId).delete();
              },
              child: Visibility(
                  visible: isDeleteIconVisible,
                  child: const Icon(Icons.delete_outline, color: kPrimaryBrandColor,)
              ),
            ),

            const Spacer(),

          ],
        ),
      ),
    );
  }
}


/*

class CartItemWidget extends StatelessWidget {
   CartItemWidget({
     required this.productImageUrl,
     required this.productName,
     required this.productPrice,
     required this.updateCartItems,
     required this.productCartQuantity,
     required this.productStockQuantity,
     required this.cartId,
  });

  String productImageUrl;
  String productName;
  String productPrice;
  bool updateCartItems;
   String productCartQuantity;
   String productStockQuantity;
   String cartId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 16.0),
      child: Container(
        padding: EdgeInsets.all(10.0),
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
                      fit: BoxFit.contain
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

                Container(
                  padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(
                      color: Colors.grey.shade200,
                      width: 2.0,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(BottomNavIcons.minus, color: Colors.black87,),
                      SizedBox(width: 30.0,),
                      Text('2', style: GoogleFonts.lato(fontWeight: FontWeight.w700, color: Colors.black87, fontSize: 16.0),),
                      SizedBox(width: 30.0,),
                      Icon(Icons.add, color: Colors.black87,),
                    ],
                  ),
                ),

                Text(
                    productPrice,
                  style: GoogleFonts.lato(fontWeight: FontWeight.w800, color: Colors.black87, fontSize: 16.0),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.only(left: 45.0, right: 10.0, top: 10.0, bottom: 10.0),
              child: Icon(Icons.delete_outline, color: kPrimaryBrandColor,),
            ),

          ],
        ),
      ),
    );
  }
}
*/