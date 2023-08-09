import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:prakty/models/user_model.dart';

class MyDb {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addFirestoreUser(MyUser myUser) async {
    try {
      await _firestore.collection("users").doc(myUser.userId).set({
        'username': myUser.username,
        'email': myUser.email,
        'description': myUser.description,
        'age': myUser.age,
        'isNormalUser': myUser.isNormalUser,
        'profilePicture': myUser.profilePicture,
        'userId': myUser.userId,
        'registeredViaGoogle': myUser.registeredViaGoogle,
        'accountCreated': Timestamp.now()
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<MyUser> getUserInfo(MyUser myUser) async {
    late String username, userId, description, email, profilePicture;
    late bool registeredViaGoogle, isNormalUser;
    late int age;
    late Timestamp accountCreated;

    try {
      DocumentSnapshot docSnapshot =
          await _firestore.collection('users').doc(myUser.userId).get();

      Map<String, dynamic>? data = docSnapshot.data() as Map<String, dynamic>;

      username = data["username"];
      email = data['email'];
      description = data['description'];
      age = data['age'];
      isNormalUser = data['isNormalUser'];
      profilePicture = data['profilePicture'];
      userId = data['userId'];
      registeredViaGoogle = data['registeredViaGoogle'];
      accountCreated = data['accountCreated'];
    } catch (e) {
      debugPrint(e.toString());
    }
    return MyUser(
        userId: userId,
        username: username,
        email: email,
        description: description,
        age: age,
        isNormalUser: isNormalUser,
        profilePicture: profilePicture,
        registeredViaGoogle: registeredViaGoogle,
        accountCreated: accountCreated);
  }

  Future<String> updateAccount(myUser) async {
    try {
      await _firestore.collection('users').doc(myUser.userId).update({
        'username': myUser.username,
        'email': myUser.email,
        'description': myUser.description,
        'isNormalUser': myUser.isNormalUser,
        'profilePicture': myUser.profilePicture,
      });
    } catch (e) {
      debugPrint(e.toString());
    }
    return '';
  }
}
