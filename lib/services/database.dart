import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:prakty/models/user_model.dart';
import 'package:prakty/providers/googlesign.dart';
import 'package:provider/provider.dart';

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
        'skillSet': myUser.skillsSet,
        'profilePicture': myUser.profilePicture,
        'userId': myUser.userId,
        'registeredViaGoogle': myUser.registeredViaGoogle,
        'accountCreated': Timestamp.now()
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> getUserInfo(context, userId) async {
    var currentUser = Provider.of<GoogleSignInProvider>(context, listen: false)
        .getCurrentUser;

    try {
      DocumentSnapshot docSnapshot =
          await _firestore.collection('users').doc(userId).get();

      Map<String, dynamic>? data = docSnapshot.data() as Map<String, dynamic>?;

      currentUser.username = data?["username"] ?? "";
      currentUser.email = data?['email'] ?? "";
      currentUser.description = data?['description'] ?? "";
      currentUser.age = data?['age'] ?? 0;
      currentUser.skillsSet = data?['skillsSet'] ?? [];
      currentUser.isNormalUser = data?['isNormalUser'] ?? false;
      currentUser.profilePicture = data?['profilePicture'] ?? "";
      currentUser.userId = data?['userId'] ?? "";
      currentUser.registeredViaGoogle = data?['registeredViaGoogle'] ?? false;
      currentUser.accountCreated = data?['accountCreated'] ?? Timestamp.now();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> updateNameAndDescription(
      String userId, String newUsername, String newDescription, context) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'username': newUsername,
        'description': newDescription,
      });
      Provider.of<GoogleSignInProvider>(context, listen: false)
          .refreshNameAndDesc(newUsername, newDescription);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> updateSkillBoxes(String userId, List<Map<String, int>> boxSet,
      // int newLvl, String newTxt
      ) async {
    print(boxSet);
    try {
      
      await _firestore.collection('users').doc(userId).update({
        'skillSet': boxSet,
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
