import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:prakty/models/user_model.dart';

class MyDb {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addFirestoreUser(MyUser myUser) async {
    print('USER ID ->>>>> ${myUser.userId}');
    print(myUser.username);
    try {
      if (myUser.userId.isNotEmpty && myUser.userId.isNotEmpty) {
        await _firestore.collection("users").doc(myUser.userId).set({
          'username': myUser.username,
          'email': myUser.email,
          'profilePicture': myUser.profilePicture,
          'userId': myUser.userId,
          'accountCreated': Timestamp.now(),
        });
      } else {
        throw Exception('Invalid userId. It must be a non-empty string.');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
