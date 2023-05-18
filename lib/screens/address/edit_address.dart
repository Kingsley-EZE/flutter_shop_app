import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shop_app/model/address.dart';
import 'package:shop_app/utilities/constants.dart';
import 'package:shop_app/components/OutlinedInputField.dart';
import 'package:shop_app/components/primary_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';


class EditAddress extends StatefulWidget {
  const EditAddress({
    required this.name,
    required this.phoneNumber,
    required this.address,
    required this.city,
    required this.additionalNote,
    required this.userId,
    required this.addressDocId
  });

  final String name;
  final String phoneNumber;
  final String address;
  final String city;
  final String additionalNote;
  final String userId;
  final String addressDocId;

  static String id = 'edit_address_screen';

  @override
  State<EditAddress> createState() => _EditAddressState();
}

class _EditAddressState extends State<EditAddress> {


  final _auth = FirebaseAuth.instance;
  final _fireStore = FirebaseFirestore.instance;

  String name = '';
  String phoneNumber = '';
  String address = '';
  String city = '';
  String additionalNote = '';
  bool showSpinner = false;

  late TextEditingController _nameController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _addressController;
  late TextEditingController _cityController;
  late TextEditingController _additionalNoteController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _phoneNumberController = TextEditingController(text: widget.phoneNumber);
    _addressController = TextEditingController(text: widget.address);
    _cityController = TextEditingController(text: widget.city);
    _additionalNoteController = TextEditingController(text: widget.additionalNote);
    name = widget.name;
    phoneNumber = widget.phoneNumber;
    address = widget.address;
    city = widget.city;
    additionalNote = widget.additionalNote;
  }



  bool validateUserInput(String name, String phoneNumber, String address, String city){
    if(name == ''){
      showSnackBar('Name cannot be empty', Colors.redAccent);
      return false;
    }else if(phoneNumber == ''){
      showSnackBar('Phone number cannot be empty', Colors.redAccent);
      return false;
    }else if(address == ''){
      showSnackBar('Address cannot be empty', Colors.redAccent);
      return false;
    }else if(city == ''){
      showSnackBar('City cannot be empty', Colors.redAccent);
      return false;
    }
    return true;
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
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10.0,),


          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: TextField(
              controller: _nameController,
              onChanged: (value){
                name = value;
              },
              decoration: const InputDecoration(
                labelText: 'Name',
                hintStyle: TextStyle(color: kHintTextColor),
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                focusColor: kPrimaryBrandColor,
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: kPrimaryBrandColor),
                ),
              ),
              cursorColor: kPrimaryBrandColor,
              maxLines: 1,
              keyboardType: TextInputType.text,
            ),
          ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                child: TextField(
                  controller: _phoneNumberController,
                  onChanged: (value){
                    phoneNumber = value;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Phone number',
                    hintStyle: TextStyle(color: kHintTextColor),
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    focusColor: kPrimaryBrandColor,
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: kPrimaryBrandColor),
                    ),
                  ),
                  cursorColor: kPrimaryBrandColor,
                  maxLines: 1,
                  keyboardType: TextInputType.number,
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                child: TextField(
                  controller: _addressController,
                  onChanged: (value){
                    address = value;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Address',
                    hintStyle: TextStyle(color: kHintTextColor),
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    focusColor: kPrimaryBrandColor,
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: kPrimaryBrandColor),
                    ),
                  ),
                  cursorColor: kPrimaryBrandColor,
                  maxLines: 4,
                  keyboardType: TextInputType.text,
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                child: TextField(
                  controller: _cityController,
                  onChanged: (value){
                    city = value;
                  },
                  decoration: const InputDecoration(
                    labelText: 'City',
                    hintStyle: TextStyle(color: kHintTextColor),
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    focusColor: kPrimaryBrandColor,
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: kPrimaryBrandColor),
                    ),
                  ),
                  cursorColor: kPrimaryBrandColor,
                  maxLines: 1,
                  keyboardType: TextInputType.text,
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                child: TextField(
                  controller: _additionalNoteController,
                  onChanged: (value){
                    additionalNote = value;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Additional note',
                    hintStyle: TextStyle(color: kHintTextColor),
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    focusColor: kPrimaryBrandColor,
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: kPrimaryBrandColor),
                    ),
                  ),
                  cursorColor: kPrimaryBrandColor,
                  maxLines: 4,
                  keyboardType: TextInputType.text,
                ),
              ),


              PrimaryMainButton(
                  buttonColor: kPrimaryBrandColor,
                  buttonText: 'Update',
                  textColor: Colors.white,
                  onPressed: ()async{
                    if(validateUserInput(name, phoneNumber, address, city)){
                      setState(() {
                        showSpinner = true;
                      });
                      final addressModel = Address(name: name, phoneNumber: phoneNumber, address: address, city: city, additionalNote: additionalNote, userId: _auth.currentUser!.uid);
                      try{
                        await _fireStore.collection(kAddresses).doc(widget.addressDocId).set(addressModel.toMap(), SetOptions(merge: true));
                        setState(() {
                          showSpinner = false;
                        });
                        showSnackBar('Updated Successfully', Colors.green);
                        Navigator.pop(context);
                      }catch(e){
                        print(e);
                        setState(() {
                          showSpinner = false;
                        });
                      }

                    }


                  },
                  horizontalValue: 16.0,
                  verticalValue: 30.0,
                  isVisible: true
              ),
            ],
          ),
        ),
      ),
    );
  }
}
