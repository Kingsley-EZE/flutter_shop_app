import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shop_app/model/product.dart';
import 'package:shop_app/utilities/constants.dart';
import 'package:shop_app/components/primary_button.dart';
import 'package:shop_app/firestore_class.dart';

class ProductDetailsScreen extends StatefulWidget {
  ProductDetailsScreen({
    required this.productName,
    required this.productPrice,
    required this.productImageUrl,
    required this.productId,
    required this.productOwnerId,
    required this.productDescription,
    required this.productQuantity
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

  bool checkIfOwner(){
    if(widget.productOwnerId == mFirestore.getCurrentUserId()){
      return false;
    }else{
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                      widget.productQuantity != null ? widget.productQuantity! : '',
                      style: GoogleFonts.lato(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),


              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 35.0),
                child: PrimaryMainButton(
                    buttonColor: kPrimaryBrandColor,
                    buttonText: 'Add to Cart',
                    textColor: Colors.white,
                    onPressed: (){},
                    horizontalValue: 0.0,
                    verticalValue: 12.0,
                    isVisible: checkIfOwner(),
                ),
              ),


            ],
          )
      ),
    );
  }
}
