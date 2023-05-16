import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shop_app/model/cartItem.dart';
import 'package:shop_app/utilities/constants.dart';

class FireStore {
  final _auth = FirebaseAuth.instance;
  final _fireStore = FirebaseFirestore.instance;
  final _firebaseStorage = FirebaseStorage.instance;

  String getCurrentUserId() {
    final currentUser = _auth.currentUser;
    var currentUserId = '';
    if(currentUser != null){
      currentUserId = currentUser.uid;
    }
    return currentUserId;
  }

  Future<String> addToCart(CartItem cartItem) async{
    try{
      await _fireStore.collection(kCarts).doc().set(cartItem.toMap(), SetOptions(merge: true));
      return 'Added Successfully';
    }catch(e){
      return 'Something went wrong';
    }

  }



}