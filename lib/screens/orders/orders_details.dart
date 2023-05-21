import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shop_app/utilities/constants.dart';
import 'package:shop_app/utilities/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../firestore_class.dart';

final _fireStore = FirebaseFirestore.instance;
FireStore mFireStore = FireStore();

class OrderDetailsScreen extends StatefulWidget {
   OrderDetailsScreen({required this.docID, required this.userId, required this.orderStatus, Key? key}) : super(key: key);

  String docID;
  String userId;
  String orderStatus;

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Order Details',
          style: GoogleFonts.poppins(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),),
        backgroundColor: kPrimaryBrandColor,
      ),
      body: SafeArea(
        child: OrderDetailsStream(docID: widget.docID, userId: widget.userId, orderStatus: widget.orderStatus,),
      ),
    );
  }
}

class OrderDetailsStream extends StatefulWidget {
   OrderDetailsStream({required this.docID, required this.userId, required this.orderStatus});

   String docID;
   String userId;
   String orderStatus;

  @override
  State<OrderDetailsStream> createState() => _OrderDetailsStreamState();
}

class _OrderDetailsStreamState extends State<OrderDetailsStream> {

  bool btnConfirmOrder = false;

  void checkIfOwner(){
    if(widget.userId == mFireStore.getCurrentUserId()){
      setState(() {
        btnConfirmOrder = false;
      });
    }else if(widget.orderStatus == 'Confirmed'){
      setState(() {
        btnConfirmOrder = false;
      });
    }
    else{
      setState(() {
        btnConfirmOrder = true;
      });
    }
  }

  @override
  void initState() {
    checkIfOwner();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: _fireStore.collection(kOrders).doc(widget.docID).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: Text("Loading"));
          }

          if(!snapshot.hasData || !snapshot.data!.exists){
            return Center(
              child: Text(
                'No orders details',
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

          final documentData = snapshot.data;

          final orderID = documentData!['title'];
          final orderDate = documentData['orderDate'];
          final orderStatus = documentData['orderStatus'];
          final shippingCharge = documentData['shippingCharge'];
          final totalAmount = documentData['totalAmount'];
          final docID = documentData.id;

          final cartList = List.from(documentData['cartItem']);
          List<OrderItemWidget> orderItemWidget = [];
          for(var item in cartList){
            final productImageUrl = item['productImageUrl'];
            final productName = item['productName'];
            final productPrice = item['productPrice'];
            final productCartQuantity = item['productCartQuantity'];

            final cartItem = OrderItemWidget(
                productName: productName,
                productPrice: productPrice,
                productImageUrl: productImageUrl,
                productCartQuantity: productCartQuantity);

            orderItemWidget.add(cartItem);
          }

          final addressMap = Map<String, dynamic>.from(documentData['address']);
          final name = addressMap['name'];
          final address = addressMap['address'];
          final city = addressMap['city'];
          final phoneNumber = addressMap['phoneNumber'];

        return Column(
          children: [

            Padding(padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Order ID:',
                      style: GoogleFonts.lato(fontWeight: FontWeight.w700, color: Colors.black87, fontSize: 18.0),
                    ),
                    Text(
                      orderID,
                      style: GoogleFonts.lato(fontWeight: FontWeight.w700, color: Colors.black87, fontSize: 18.0),
                    ),
                  ],
                ),
                const SizedBox(height: 10.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Order Date:',
                      style: GoogleFonts.lato(fontWeight: FontWeight.w700, color: Colors.black87, fontSize: 18.0),
                    ),
                    Text(
                      orderDate,
                      style: GoogleFonts.lato(fontWeight: FontWeight.w700, color: Colors.black87, fontSize: 18.0),
                    ),
                  ],
                ),
                const SizedBox(height: 10.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Order Status:',
                      style: GoogleFonts.lato(fontWeight: FontWeight.w700, color: Colors.black87, fontSize: 18.0),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                      decoration: BoxDecoration(
                        color: orderStatus == 'Pending' ? Colors.yellow.shade600 : Colors.green.shade600,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Text(
                        orderStatus,
                        style: GoogleFonts.lato(
                            fontWeight: FontWeight.w500,
                            color: orderStatus == 'Pending' ? Colors.black87 : Colors.white,
                            fontSize: 18.0),
                      ),
                    ),
                  ],
                ),
              ],
            ),),

            Expanded(child: ListView(children: orderItemWidget,)),

            Padding(padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Name',
                        style: GoogleFonts.lato(fontWeight: FontWeight.w700, color: Colors.black87, fontSize: 18.0),
                      ),
                      Text(
                        name,
                        style: GoogleFonts.lato(fontWeight: FontWeight.w700, color: Colors.black87, fontSize: 18.0),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Address:',
                        style: GoogleFonts.lato(fontWeight: FontWeight.w700, color: Colors.black87, fontSize: 18.0),
                      ),
                      Text(
                        address,
                        style: GoogleFonts.lato(fontWeight: FontWeight.w700, color: Colors.black87, fontSize: 18.0),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'City:',
                        style: GoogleFonts.lato(fontWeight: FontWeight.w700, color: Colors.black87, fontSize: 18.0),
                      ),
                      Text(
                        city,
                        style: GoogleFonts.lato(fontWeight: FontWeight.w700, color: Colors.black87, fontSize: 18.0),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Phone number:',
                        style: GoogleFonts.lato(fontWeight: FontWeight.w700, color: Colors.black87, fontSize: 18.0),
                      ),
                      Text(
                        phoneNumber,
                        style: GoogleFonts.lato(fontWeight: FontWeight.w700, color: Colors.black87, fontSize: 18.0),
                      ),
                    ],
                  ),
                ],
              ),),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
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
                        '\$$shippingCharge',
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
                        '\$$totalAmount',
                        style: GoogleFonts.lato(
                            fontSize: 20.0,
                            color: Colors.black87,
                            fontWeight: FontWeight.w800
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 30.0,),

                  Visibility(
                    visible: btnConfirmOrder,
                    child: GestureDetector(
                      onTap: ()async{

                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  CircularProgressIndicator(),
                                  SizedBox(height: 16.0),
                                  Text(
                                    'Confirming...',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );

                        final orderStatusMap = <String, dynamic>{};
                        orderStatusMap['orderStatus'] = 'Confirmed';

                        try{
                          await _fireStore.collection(kOrders).doc(docID).update(orderStatusMap);
                          setState(() {
                            btnConfirmOrder = false;
                          });
                          Navigator.pop(context);
                        }catch(e){
                          Navigator.pop(context);
                          print(e);
                        }

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
                            'Confirm Order',
                            style: GoogleFonts.lato(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600
                            ),
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


class OrderItemWidget extends StatelessWidget {
  const OrderItemWidget({
    required this.productName,
    required this.productPrice,
    required this.productImageUrl,
    required this.productCartQuantity,
    super.key,
  });

  final String productName;
  final String productPrice;
  final String productImageUrl;
  final String productCartQuantity;

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
                      image: NetworkImage(productImageUrl),
                      fit: BoxFit.cover
                  )
              ),
            ),

            SizedBox(width: 10.0,),

            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productName,
                  style: GoogleFonts.lato(fontWeight: FontWeight.w700, color: Colors.black87, fontSize: 18.0),
                ),

                Text(
                  productPrice,
                  style: GoogleFonts.lato(fontWeight: FontWeight.w800, color: Colors.black87, fontSize: 16.0),
                ),

                Text(
                  'Quantity: $productCartQuantity',
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

