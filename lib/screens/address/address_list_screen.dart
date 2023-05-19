import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shop_app/model/address.dart';
import 'package:shop_app/utilities/constants.dart';
import 'add_address.dart';
import 'edit_address.dart';
import 'package:shop_app/screens/checkout/checkout_screen.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

final _auth = FirebaseAuth.instance;
final _fireStore = FirebaseFirestore.instance;

class AddressListScreen extends StatefulWidget {
  const AddressListScreen({Key? key}) : super(key: key);

  static String id = 'address_list_screen';

  @override
  State<AddressListScreen> createState() => _AddressListScreenState();
}

class _AddressListScreenState extends State<AddressListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Addresses',
          style: GoogleFonts.poppins(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),),
        backgroundColor: kPrimaryBrandColor,
      ),
      body: Column(
        children: [

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: GestureDetector(
              onTap: (){
                Navigator.pushNamed(context, AddAddress.id);
              },
              child: Container(
                width: double.infinity,
                height: 55.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7.0),
                  border: Border.all(
                    color: kPrimaryBrandColor,
                    width: 2.0,
                  )
                ),
                child: Center(
                  child: Text(
                    'Add Address',
                    style: GoogleFonts.lato(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w700,
                      color: kPrimaryBrandColor
                    ),
                  ),
                ),
              ),
            ),
          ),

          AddressListStream(),

        ],
      ),
    );
  }
}



class AddressListStream extends StatelessWidget {
  const AddressListStream({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _fireStore.collection(kAddresses).where(kUserId, isEqualTo: _auth.currentUser?.uid).snapshots(),
        builder: (BuildContext context, snapshot){

          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(child: Text(
              'Loading',
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

          final addressItems = snapshot.data!.docs;

          if(addressItems.isEmpty){
            return Center(
              child: Text(
                'No address added yet',
                style: GoogleFonts.lato(
                    fontSize: 20.0,
                    color: Colors.black54),
              ),
            );
          }

          List<AddressCard> addressCardItem = [];

          for(var addressItem in addressItems){
            final name = addressItem.get('name');
            final phoneNumber = addressItem.get('phoneNumber');
            final address = addressItem.get('address');
            final city = addressItem.get('city');
            final additionalNote = addressItem.get('additionalNote');
            final userId = addressItem.get('userId');
            final addressDocId = addressItem.id;

            final addressCard = AddressCard(name: name, phoneNumber: phoneNumber, address: address, city: city, additionalNote: additionalNote, userId: userId, addressDocId: addressDocId,);

            addressCardItem.add(addressCard);
          }

          return Expanded(
              child: ListView(
                children: addressCardItem,
              )
          );

        }
    );
  }
}

class AddressCard extends StatelessWidget {

  final String name;
  final String phoneNumber;
  final String address;
  final String city;
  final String additionalNote;
  final String userId;
  final String addressDocId;

  const AddressCard({
    required this.name,
    required this.phoneNumber,
    required this.address,
    required this.city,
    required this.additionalNote,
    required this.userId,
    required this.addressDocId
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 7.0),
      child: GestureDetector(
        onTap: (){
          Navigator.push(context,
            MaterialPageRoute(builder: (context) => CheckoutScreen(
                name: name,
                phoneNumber: phoneNumber,
                address: address,
                city: city,
                additionalNote: additionalNote,
                userId: userId,),
            ),);
        },
        child: Slidable(
          startActionPane: ActionPane(
            extentRatio: 0.3,
              motion: ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) async {
                    await _fireStore.collection(kAddresses).doc(addressDocId).delete();
                  },
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  icon: Icons.delete_outline_outlined,
                  label: 'Delete',
                  borderRadius: BorderRadius.circular(7.0),
                ),
              ]),
          endActionPane: ActionPane(
              extentRatio: 0.3,
              motion: ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) => {

                  Navigator.push(context,
                  MaterialPageRoute(builder: (context) => EditAddress(
                    name: name,
                    phoneNumber: phoneNumber,
                    address: address,
                    city: city,
                    additionalNote: additionalNote,
                    userId: userId,
                    addressDocId: addressDocId,
                  ),
                  ),)

                },
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  icon: Icons.edit,
                  label: 'Edit',
                  borderRadius: BorderRadius.circular(7.0),

                ),
              ]),
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
                ],
              )
          ),
        ),
      ),
    );
  }
}

