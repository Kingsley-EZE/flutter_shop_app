import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shop_app/utilities/constants.dart';
import 'add_address.dart';


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
          )
        ],
      ),
    );
  }
}
