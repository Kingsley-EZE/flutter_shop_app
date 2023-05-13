import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:shop_app/model/product.dart';
import 'package:shop_app/utilities/constants.dart';
import 'package:shop_app/components/navigate_back_arrow.dart';
import 'package:shop_app/components/primary_button.dart';
import 'package:shop_app/components/OutlinedInputField.dart';
import 'package:shop_app/utilities/image_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

final imageHelper = ImageHelper();

class AddProductsScreen extends StatefulWidget {
  const AddProductsScreen({Key? key}) : super(key: key);

  static const String id = 'add_product_screen';

  @override
  State<AddProductsScreen> createState() => _AddProductsScreen();
}

class _AddProductsScreen extends State<AddProductsScreen> {

  final _auth = FirebaseAuth.instance;
  final _fireStore = FirebaseFirestore.instance;
  final _firebaseStorage = FirebaseStorage.instance;

  File? _image;
  String productName = '';
  String productPrice = '';
  String productDescription = '';
  String productQuantity = '';
  String productImageUrl = '';
  String? imageUrl = '';
  bool showSpinner = false;

  void showSnackBar(String message, Color backgroundColor){
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  bool validateUserInput(String productName, String productPrice, String productDescription, String productQuantity, String? imageUrl){

    if(imageUrl == ''){
      showSnackBar('Please choose your product image', Colors.redAccent);
      return false;
    }else if(productName == ''){
      showSnackBar('Product name cannot be empty', Colors.redAccent);
      return false;
    }else if(productPrice == ''){
      showSnackBar('Product price cannot be empty', Colors.redAccent);
      return false;
    }else if(productDescription == ''){
      showSnackBar('Product description cannot be empty', Colors.redAccent);
      return false;
    }else if(productQuantity == ''){
      showSnackBar('Product quantity cannot be empty', Colors.redAccent);
      return false;
    }

    return true;
  }

  void uploadProduct(File? file, String productName, String productPrice, String productDescription, String productQuantity) async{
    setState(() {
      showSpinner = true;
    });
    try{
      if(file != null){
        var fileName = file.path.split('/').last;
        var firebaseStorageRef = _firebaseStorage.ref().child('products/$fileName');

        var task = await firebaseStorageRef.putFile(File(file.path));

        var downloadUrl = await task.ref.getDownloadURL();
        productImageUrl = downloadUrl.toString();

        getProductInfo(productName, productPrice, productDescription, productQuantity, productImageUrl);

        setState(() {
          showSpinner = false;
        });
        showSnackBar('Added Successfully', Colors.green);
        Navigator.pop(context);

      }
    }catch(e){
      setState(() {
        showSpinner = false;
      });
      showSnackBar('$e', Colors.redAccent);
    }
  }

  void getProductInfo(String productName, String productPrice, String productDescription, String productQuantity, String imageUrl) async{
    final product = Product(
        userId: _auth.currentUser?.uid,
        email: _auth.currentUser?.email,
        productName: productName,
        productPrice: productPrice,
        productDescription: productDescription,
        productQuantity: productQuantity,
        productImageUrl: imageUrl
    );

    await _fireStore.collection(kProducts).doc().set(product.toMap(), SetOptions(merge: true));

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: BackArrowWidget(),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: GestureDetector(
                      onTap: () async{
                        try{
                          final chosenImage = await imageHelper.pickImage();
                          if(chosenImage != null){
                            File? img = File(chosenImage.path);
                            img = await imageHelper.cropImage(file: img, cropStyle: CropStyle.rectangle);
                            setState(() {
                              _image = img;
                              imageUrl = _image?.path;
                            });
                          }
                        }catch(e) {
                          print(e);
                        }
                      },
                      child: Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 250,
                            color: Colors.grey[300],
                            child: _image != null ? Image.file(_image!, fit: BoxFit.cover,) : Container(),
                          ),

                          Positioned(
                            right: 0,
                            left: 0,
                            top: 0,
                            bottom: 0,
                              child: Center(
                                child: Text(
                                  _image != null ? '' : 'Tap to choose your product image',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black54
                                  ),
                                ),
                              ),)
                        ]
                      ),
                    ),
                  ),

                  OutlinedInputField(
                    labelText: 'Product name',
                    onChanged: (String value) {
                      productName = value;
                    },
                    keyboard: TextInputType.text,
                    maxLines: 1,
                  ),

                  OutlinedInputField(
                    labelText: 'Product price',
                    onChanged: (String value) {
                      productPrice = 'NGN$value';
                    },
                    keyboard: TextInputType.number,
                    maxLines: 1,
                  ),

                  OutlinedInputField(
                    labelText: 'Product description',
                    onChanged: (String value) {
                      productDescription = value;
                    },
                    keyboard: TextInputType.text,
                    maxLines: 7,
                  ),

                  OutlinedInputField(
                    labelText: 'Product quantity',
                    onChanged: (String value) {
                      productQuantity = value;
                    },
                    keyboard: TextInputType.number,
                    maxLines: 1,
                  ),

                  PrimaryMainButton(
                      buttonColor: kPrimaryBrandColor,
                      buttonText: 'Submit',
                      textColor: Colors.white,
                      onPressed: () async{
                          if(validateUserInput(productName, productPrice, productDescription, productQuantity, imageUrl)){
                            uploadProduct(_image, productName, productPrice, productDescription, productQuantity);
                          }
                      },
                      horizontalValue: 16.0,
                      verticalValue: 30.0),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


