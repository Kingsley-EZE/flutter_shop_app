import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shop_app/model/address.dart';
import 'package:shop_app/utilities/constants.dart';
import 'package:shop_app/components/OutlinedInputField.dart';
import 'package:shop_app/components/primary_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';


class AddAddress extends StatefulWidget {
  const AddAddress({Key? key}) : super(key: key);

  static String id = 'add_address_screen';

  @override
  State<AddAddress> createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {

  final _auth = FirebaseAuth.instance;
  final _fireStore = FirebaseFirestore.instance;
  
  String name = '';
  String phoneNumber = '';
  String address = '';
  String city = '';
  String additionalNote = '';
  bool showSpinner = false;


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
              OutlinedInputField(
                  controller: null,
                  labelText: 'Name',
                  onChanged: (String value){
                    name = value;
                  },
                  keyboard: TextInputType.text,
                  maxLines: 1,
              ),

              OutlinedInputField(
                controller: null,
                labelText: 'Phone number',
                onChanged: (String value){
                    phoneNumber = value;
                },
                keyboard: TextInputType.number,
                maxLines: 1,
              ),

              OutlinedInputField(
                controller: null,
                labelText: 'Address',
                onChanged: (String value){
                    address = value;
                },
                keyboard: TextInputType.text,
                maxLines: 4,
              ),

              OutlinedInputField(
                controller: null,
                labelText: 'City',
                onChanged: (String value){
                    city = value;
                },
                keyboard: TextInputType.text,
                maxLines: 1,
              ),

              OutlinedInputField(
                controller: null,
                labelText: 'Additional note',
                onChanged: (String value){
                    additionalNote = value;
                },
                keyboard: TextInputType.text,
                maxLines: 4,
              ),

              PrimaryMainButton(
                  buttonColor: kPrimaryBrandColor,
                  buttonText: 'Submit',
                  textColor: Colors.white,
                  onPressed: ()async{
                    setState(() {
                      showSpinner = true;
                    });
                    if(validateUserInput(name, phoneNumber, address, city)){
                      final addressModel = Address(name: name, phoneNumber: phoneNumber, address: address, city: city, additionalNote: additionalNote, userId: _auth.currentUser!.uid);
                      try{
                        await _fireStore.collection(kAddresses).doc().set(addressModel.toMap(), SetOptions(merge: true));
                        setState(() {
                          showSpinner = false;
                        });
                        showSnackBar('Added Successfully', Colors.green);
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
