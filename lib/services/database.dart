import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:prakty/models/user_model.dart';
import 'package:prakty/providers/edituser.dart';
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
        'location': myUser.location,
        'isAccountTypeUser': myUser.isAccountTypeUser,
        'skillsSet': myUser.skillsSet,
        'profilePicture': myUser.profilePicture,
        'userId': myUser.userId,
        'jobVacancy': myUser.jobVacancy,
        'accountCreated': Timestamp.now()
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> getUserInfo(context, String userId) async {
    var currentUser = Provider.of<GoogleSignInProvider>(context, listen: false)
        .getCurrentUser;

    try {
      if (userId.isNotEmpty) {
        DocumentSnapshot docSnapshot =
            await _firestore.collection('users').doc(userId).get();

        Map<String, dynamic>? data =
            docSnapshot.data() as Map<String, dynamic>?;

        currentUser.username = data?["username"] ?? "";
        currentUser.email = data?['email'] ?? "";
        currentUser.description = data?['description'] ?? "";
        currentUser.age = data?['age'] ?? 0;
        currentUser.skillsSet =
            (data?['skillsSet'] as List<dynamic>?)?.map((dynamic item) {
                  final Map<String, int> skill = Map<String, int>.from(item);
                  return skill;
                }).toList() ??
                [];
        currentUser.location = data?['location'] ?? "";
        currentUser.isAccountTypeUser = data?['isAccountTypeUser'] ?? true;
        currentUser.profilePicture = data?['profilePicture'] ?? "";
        currentUser.userId = data?['userId'] ?? "";
        currentUser.jobVacancy = data?['jobVacancy'] ?? false;
        currentUser.accountCreated = data?['accountCreated'] ?? Timestamp.now();
        Provider.of<EditUser>(context, listen: false).setSkillBoxes =
            currentUser.skillsSet;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<List<String>?> updateInfoFields(String userId, String newUsername,
      String newDescription, String newLocation, int newAge) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'username': newUsername,
        'description': newDescription,
        'location': newLocation,
        'age': newAge,
      });
      return [newUsername, newDescription, newLocation, newAge.toString()];
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<List<Map<String, int>>?> updateSkillBoxes(
      String userId, List<Map<String, int>> actuallSkillSet) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'skillsSet': actuallSkillSet,
      });
      return actuallSkillSet;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<String?> uploadImageToStorage(String userId, imgFile) async {
    final storage = FirebaseStorage.instance;

    try {
      final storageReference =
          storage.ref().child('profile_pictures/$userId.jpg');
      await storageReference.putFile(imgFile!);
      final imageUrl = await storageReference.getDownloadURL();

      await _firestore
          .collection('users')
          .doc(userId)
          .update({'profilePicture': imageUrl});

      return imageUrl;
    } catch (e) {
      debugPrint('Error uploading image to Firebase Storage: $e');
      return null;
    }
  }

  Future<List> downloadJobAds() async {
    try {
      final collection = _firestore.collection('/jobAd');
      final QuerySnapshot jobCards = await collection.get();
      final List myJobList = jobCards.docs.map((doc) => doc.data()).toList();
      return myJobList;
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Future<List<Map>> downloadUsersStates() async {
    try {
      List<Map> usrsWithNotices = [];
      final collection = _firestore.collection('/users');
      final QuerySnapshot usersCollection = await collection.get();
      final List myUsersList =
          usersCollection.docs.map((doc) => doc.data()).toList();
      for (int i = 0; i < myUsersList.length; i++) {
        var isVacan = myUsersList[i]['jobVacancy'];
        if (isVacan == true) {
          usrsWithNotices.add(myUsersList[i]);
        }
      }
      return usrsWithNotices;
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Future<bool> addUserJobNotice(userId, newValue) async {
    try {
      await _firestore
          .collection('/users')
          .doc(userId)
          .update({'jobVacancy': newValue});
      return false;
    } catch (e) {
      debugPrint(e.toString());
      return true;
    }
  }

  Future<List?> addFirestoreJobAd(
      userId,
      noticePhoto,
      jobName,
      companyName,
      jobEmail,
      jobPhone,
      jobLocation,
      jobQualification,
      jobDescription,
      canRemotely) async {
    late String code;
    String generateRandomCode() {
      const characters = 'abcdefghijklmnopqrstuvwxyz0123456789';

      final randomChars = List.generate(22, (index) {
        final randomIndex = Random().nextInt(characters.length);
        return characters[randomIndex];
      });
      return 'j0bNum${randomChars.join()}';
    }

    code = generateRandomCode();

    try {
      String? imageUrl;
      if (noticePhoto != 'no_image') {
        final storageReference =
            FirebaseStorage.instance.ref().child('job_ad_pictures/$code.jpg');
        await storageReference.putFile(noticePhoto);
        imageUrl = await storageReference.getDownloadURL();
      }
      await _firestore.collection("jobAd").doc(code).set({
        'belongsToUser': userId,
        'jobImage': imageUrl,
        'jobName': jobName,
        'companyName': companyName,
        'jobEmail': jobEmail,
        'jobPhone': jobPhone,
        'jobLocation': jobLocation,
        'jobQualification': jobQualification,
        'jobDescription': jobDescription,
        'canRemotely': canRemotely
      });
      return [
        jobName,
        companyName,
        jobEmail,
        jobPhone,
        companyName,
        jobLocation,
        jobDescription,
        canRemotely
      ];
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<List<String>?> takeAdOwnersData(ownerId) async {
    try {
      DocumentSnapshot docSnapshot =
          await _firestore.collection('users').doc(ownerId).get();
      Map<String, dynamic> userInfo =
          docSnapshot.data() as Map<String, dynamic>;

      List<String> userPpAndUsername = [];
      userPpAndUsername.addAll([
        userInfo['profilePicture'],
        userInfo['username'],
      ]);

      return userPpAndUsername;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}
