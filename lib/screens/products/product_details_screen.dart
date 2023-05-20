import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shop_app/model/cartItem.dart';
import 'package:shop_app/model/product.dart';
import 'package:shop_app/utilities/constants.dart';
import 'package:shop_app/components/primary_button.dart';
import 'package:shop_app/firestore_class.dart';
import 'package:shop_app/screens/cart_list_screen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class ProductDetailsScreen extends StatefulWidget {
  ProductDetailsScreen({
    this.productName = '',
    this.productPrice = '',
    this.productImageUrl = '',
    this.productId = '',
    this.productOwnerId = '',
    this.productDescription = '',
    this.productQuantity = '',
});

  static const String id = 'product_details_screen';

  String productName;
  String productPrice;
  String productId;
  String productOwnerId;
  String? productImageUrl;
  String? productDescription;
  String? productQuantity;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {

  FireStore mFirestore = FireStore();
  bool showSpinner = false;
  late bool btnAddCartVisible;
  bool btnGoToCartVisible = false;

  void addToCart()async{
    setState(() {
      showSpinner = true;
    });
    final cartItem = CartItem(
      userId: mFirestore.getCurrentUserId(),
      productOwnerId: widget.productOwnerId,
      productId: widget.productId,
      productName: widget.productName,
      productPrice: widget.productPrice,
      productImageUrl: widget.productImageUrl!,
      productCartQuantity: kDefaultQuantity,
      productStockQuantity: widget.productQuantity!,
    );

    final addedToCart = await mFirestore.addToCart(cartItem);

    setState(() {
      showSpinner = false;
    });

    if(addedToCart == 'Added Successfully'){
      showSnackBar('Added Successfully', Colors.green);
      setState(() {
        btnAddCartVisible = false;
        btnGoToCartVisible = true;
      });
    }else{
      showSnackBar('Something went wrong', Colors.redAccent);
      setState(() {
        btnAddCartVisible = true;
        btnGoToCartVisible = false;
      });
    }

  }

  bool checkIfOwner(){
    if(widget.productOwnerId == mFirestore.getCurrentUserId()){
      setState(() {
        btnAddCartVisible = false;
      });
      return btnAddCartVisible;
    }else{
      setState(() {
        btnAddCartVisible = true;
      });
      return btnAddCartVisible;
    }
  }

  void checkIfProductExist()async{
    try{
      final _firestore = FirebaseFirestore.instance;

      final ref = _firestore.collection(kCarts)
          .where(kUserId, isEqualTo: mFirestore.getCurrentUserId())
          .where(kProductId, isEqualTo: widget.productId);

      final docSnap = await ref.get();
      if(docSnap.size > 0 && int.parse(widget.productQuantity!) > 0){
        setState(() {
          btnAddCartVisible = false;
          btnGoToCartVisible = true;
        });
      }else{

      }
    }catch(e){
      print('CHECK IF PRODUCT IN CART ERROR: $e');
    }

  }

  @override
  void initState() {
    checkIfOwner();
    checkIfProductExist();
    super.initState();
  }

  void showSnackBar(String message, Color backgroundColor){
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 320.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                          image: DecorationImage(
                              image: NetworkImage(widget.productImageUrl!),
                              fit: BoxFit.cover
                          )
                      ),
                    ),
                    Positioned(
                      left: 10.0,
                      top: 10.0,
                      child: GestureDetector(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: Icon(
                            Icons.cancel,
                            size: 30,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),

                  ],
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 26.0),
                  child: Text(
                      widget.productName,
                      style: GoogleFonts.lato(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, ),
                  child: Text(
                    widget.productDescription != null ? widget.productDescription! : '',
                    style: GoogleFonts.lato(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                      height: 1.5
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                  child: Text(
                    widget.productPrice,
                    style: GoogleFonts.lato(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      Text(
                        'Stock Quantity: ',
                        style: GoogleFonts.lato(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),

                      Text(
                        int.parse(widget.productQuantity!) > 0 ? widget.productQuantity! : 'Out of stock',
                        style: GoogleFonts.lato(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                          color: int.parse(widget.productQuantity!) > 0 ? Colors.black87 : Colors.redAccent,
                        ),
                      ),
                    ],
                  ),
                ),

                Stack(
                  alignment: Alignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 35.0),
                      child: PrimaryMainButton(
                        buttonColor: kPrimaryBrandColor,
                        buttonText: 'Add to Cart',
                        textColor: Colors.white,
                        onPressed: (){
                          addToCart();
                        },
                        horizontalValue: 0.0,
                        verticalValue: 12.0,
                        isVisible: btnAddCartVisible,
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 35.0),
                      child: PrimaryMainButton(
                        buttonColor: kPrimaryBrandColor,
                        buttonText: 'Go to Cart',
                        textColor: Colors.white,
                        onPressed: (){
                          Navigator.pushNamed(context, CartListScreen.id);
                        },
                        horizontalValue: 0.0,
                        verticalValue: 12.0,
                        isVisible: btnGoToCartVisible,
                      ),
                    ),
                  ],
                ),

              ],
            )
        ),
      ),
    );
  }
}
