import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shop_app/utilities/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../firestore_class.dart';
import '../orders/orders_details.dart';
import 'package:rxdart/rxdart.dart';


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
    return Scaffold(
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
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OrderItemStream(),
          ],
        ),
      ),
    );
  }
}

class OrderItemStream extends StatelessWidget {
  const OrderItemStream({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _fireStore.collection(kOrders).where(kUserId, isEqualTo: mFireStore.getCurrentUserId()).snapshots(),
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

          final orderItems = snapshot.data!.docs;
          List<OrderItemWidget> orderItemWidgetList = [];
          for(var orderItem in orderItems){
            final orderId = orderItem.get('title');
            final orderPrice = orderItem.get('totalAmount');
            final orderImageUrl = orderItem.get('imageUrl');
            final orderStatus = orderItem.get('orderStatus');
            final userId = orderItem.get('userId');
            final docID = orderItem.id;

            final itemWidget = OrderItemWidget(
              orderId: orderId,
              orderPrice: orderPrice,
              orderImageUrl: orderImageUrl,
              orderStatus: orderStatus,
              docID: docID,
              userId: userId,);

            orderItemWidgetList.add(itemWidget);
          }

          return Expanded(
              child: ListView(
                children: orderItemWidgetList,
              ));

          }
    );
  }
}


/*
class OrderItemStream extends StatelessWidget {
  const OrderItemStream({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final userOrdersStream = _fireStore
        .collection(kOrders)
        .where(kUserId, isEqualTo: mFireStore.getCurrentUserId())
        .snapshots()
        .map((QuerySnapshot<Map<String, dynamic>> snapshot) {
      return snapshot.docs;
    });

    final productOwnerOrdersStream = _fireStore
        .collection(kOrders)
        .where(kProductOwnerId, isEqualTo: mFireStore.getCurrentUserId())
        .snapshots()
        .map((QuerySnapshot<Map<String, dynamic>> snapshot) {
      return snapshot.docs;
    });

    final mergedStream = Rx.merge([userOrdersStream, productOwnerOrdersStream]);

    return StreamBuilder<List<QueryDocumentSnapshot<Object?>>>(
      stream: mergedStream,
      builder: (BuildContext context, AsyncSnapshot<List<QueryDocumentSnapshot<Object?>>> snapshot){
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: Text("Loading"));
        }

        if (!snapshot.hasData) {
          return Center(
            child: Text(
              'No orders yet',
              style: GoogleFonts.lato(fontSize: 20.0, color: Colors.black54),
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Something went wrong',
              style: GoogleFonts.lato(fontSize: 20.0, color: Colors.black54),
            ),
          );
        }

        final userOrders = snapshot.data ?? [];

        List<OrderItemWidget> orderItemWidgetList = [];

        for(var orderItem in userOrders){
          final orderId = orderItem.get('title');
          final orderPrice = orderItem.get('totalAmount');
          final orderImageUrl = orderItem.get('imageUrl');
          final orderStatus = orderItem.get('orderStatus');
          final userId = orderItem.get('userId');
          final docID = orderItem.id;

          final itemWidget = OrderItemWidget(
            orderId: orderId,
            orderPrice: orderPrice,
            orderImageUrl: orderImageUrl,
            orderStatus: orderStatus,
            docID: docID,
            userId: userId,);

          orderItemWidgetList.add(itemWidget);
        }

        return Expanded(
            child: ListView(
              children: orderItemWidgetList,
            ));

      },
    );
  }
}
*/

class OrderItemWidget extends StatelessWidget {
  const OrderItemWidget({
    required this.orderId,
    required this.orderPrice,
    required this.orderImageUrl,
    required this.orderStatus,
    required this.docID,
    required this.userId,
    super.key,
  });

  final String orderId;
  final String orderPrice;
  final String orderImageUrl;
  final String orderStatus;
  final String docID;
  final String userId;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context,
          MaterialPageRoute(builder: (context) => OrderDetailsScreen(docID: docID, userId: userId,),
          ),);
      },
      child: Padding(
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
                        image: NetworkImage(orderImageUrl),
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
                    orderId.substring(0, 18),
                    style: GoogleFonts.lato(fontWeight: FontWeight.w700, color: Colors.black87, fontSize: 18.0),
                  ),

                  Text(
                    orderPrice,
                    style: GoogleFonts.lato(fontWeight: FontWeight.w800, color: Colors.black87, fontSize: 16.0),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                    decoration: BoxDecoration(
                      color: orderStatus == 'Pending' ? Colors.yellow.shade600 : Colors.green.shade600,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Text(
                      orderStatus,
                      style: GoogleFonts.lato(
                          fontWeight: FontWeight.w500,
                          color: orderStatus == 'Pending' ? Colors.black87 : Colors.white,
                          fontSize: 16.0),
                    ),
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}
