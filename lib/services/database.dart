import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:prakty/models/advertisements_model.dart';
import 'package:prakty/models/user_model.dart';
import 'package:prakty/providers/edituser.dart';
import 'package:prakty/providers/googlesign.dart';
import 'package:provider/provider.dart';

class MyDb {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> saveFav(
      bool isAddedToFav, String userId, String noticeId) async {
    try {
      var doc = _firestore.collection('users').doc(userId);

      if (isAddedToFav) {
        doc.update({
          'likedOffers': FieldValue.arrayRemove([noticeId]),
        });
      } else {
        doc.update({
          'likedOffers': FieldValue.arrayUnion([noticeId]),
        });
      }
      return 'success';
    } catch (e) {
      return e.toString();
    }
  }

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
        'likedOffers': myUser.likedOffers,
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

        Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;

        currentUser.username = data["username"] ?? "";
        currentUser.email = data['email'] ?? "";
        currentUser.description = data['description'];
        currentUser.phoneNum = data['phoneNum'];
        currentUser.age = data['age'];
        currentUser.placeId = data['placeId'];
        currentUser.skillsSet =
            (data['skillsSet'] as List<dynamic>?)?.map((dynamic item) {
                  final Map<String, int> skill = Map<String, int>.from(item);
                  return skill;
                }).toList() ??
                [];
        currentUser.likedOffers = List.from(data['likedOffers']);
        currentUser.location = data['location'];
        currentUser.isAccountTypeUser = data['isAccountTypeUser'];
        currentUser.profilePicture = data['profilePicture'];
        currentUser.userId = data['userId'];
        currentUser.jobVacancy = data['jobVacancy'];
        currentUser.accountCreated = data['accountCreated'] ?? Timestamp.now();
        Provider.of<EditUser>(context, listen: false).setSkillBoxes =
            currentUser.skillsSet;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<List<dynamic>?> updateInfoFields(
      bool isAccountTypeUser,
      String userId,
      String newUsername,
      String newDescription,
      String? newLocation,
      String? placeId,
      int? newAge) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'username': newUsername,
        'description': newDescription,
        'location': newLocation,
        'placeId': placeId,
        'age': newAge,
      });
      return [newUsername, newDescription, newLocation, placeId, newAge];
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<List<String>?> updateContactInfo(
      String email, String phoneNum, User user) async {
    String providerId = user.providerData[0].providerId;

    try {
      await _firestore.collection('users').doc(user.uid).update({
        'email': email,
        'phoneNum': phoneNum,
      });
      if (providerId == 'password') {
        user.verifyBeforeUpdateEmail(email);
      }
      return [email, phoneNum];
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<List<Map<String, int>>?> updateSkillBoxes(
      String userId, List<Map<String, int>> actuallSkillSet) async {
    try {
      if (actuallSkillSet.isNotEmpty) {
        await _firestore.collection('users').doc(userId).update({
          'skillsSet': actuallSkillSet,
        });
      } else {
        debugPrint('actuallSkillSet is empty. Not updating Firestore.');
      }
      return actuallSkillSet;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<String?> uploadImageToStorage(String userId, File? imgFile) async {
    final storage = FirebaseStorage.instance;

    try {
      String? imageUrl = '';

      if (imgFile != null) {
        final storageReference =
            storage.ref().child('profile_pictures/$userId.jpg');
        await storageReference.putFile(imgFile);
        imageUrl = await storageReference.getDownloadURL();
      } else {
        imageUrl = null;
      }

      await _firestore
          .collection('users')
          .doc(userId)
          .update({'profilePicture': imageUrl});

      return imageUrl;
    } catch (e) {
      debugPrint('Error uploading image to Firebase Storage: $e');
      return '';
    }
  }

  Future<List<JobAdModel>> downloadJobAds() async {
    try {
      List<JobAdModel> advertInfo = [];

      final collection = _firestore.collection('/jobAd');
      final QuerySnapshot jobCards = await collection.get();

      final List<Map<String, dynamic>> myJobList = jobCards.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      for (int i = 0; i < myJobList.length; i++) {
        advertInfo.add(JobAdModel(
          jobId: myJobList[i]['jobId'],
          belongsToUser: myJobList[i]['belongsToUser'],
          jobName: myJobList[i]['jobName'],
          companyName: myJobList[i]['companyName'],
          jobEmail: myJobList[i]['jobEmail'],
          jobImage: myJobList[i]['jobImage'],
          jobPhone: myJobList[i]['jobPhone'],
          jobLocation: myJobList[i]['jobLocation'],
          jobQualification: myJobList[i]['jobQualification'],
          jobDescription: myJobList[i]['jobDescription'],
          canRemotely: myJobList[i]['canRemotely'],
          arePaid: myJobList[i]['arePaid'],
        ));
      }
      return advertInfo;
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Future<List<MyUser>> downloadUsersStates() async {
    try {
      List<MyUser> usrsWithNotices = [];

      final collection = _firestore.collection('/users');
      final QuerySnapshot usersCollection = await collection.get();

      final List<Map<String, dynamic>> myUsersList = usersCollection.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      for (int i = 0; i < myUsersList.length; i++) {
        if (myUsersList[i]['jobVacancy'] == true) {
          usrsWithNotices.add(MyUser(
              userId: myUsersList[i]['userId'],
              username: myUsersList[i]['username'],
              age: myUsersList[i]['age'],
              description: myUsersList[i]['description'],
              phoneNum: myUsersList[i]['phoneNum'],
              location: myUsersList[i]['location'],
              placeId: myUsersList[i]['placeId'],
              isAccountTypeUser: myUsersList[i]['isAccountTypeUser'],
              skillsSet: (myUsersList[i]['skillsSet'] as List<dynamic>)
                  .map((item) => Map<String, int>.from(item))
                  .toList(),
              email: myUsersList[i]['email'],
              profilePicture: myUsersList[i]['profilePicture'],
              likedOffers: List.from(myUsersList[i]['likedOffers']),
              jobVacancy: myUsersList[i]['jobVacancy'],
              accountCreated: myUsersList[i]['accountCreated']));
        }
      }

      return usrsWithNotices;
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Future<List<JobAdModel>?> downloadMyOffers(String userId) async {
    try {
      List<JobAdModel> myJobNotices = [];
      QuerySnapshot<Map<String, dynamic>> myNotices = await _firestore
          .collection('jobAd')
          .where('belongsToUser', isEqualTo: userId)
          .get();

      final List<Map<String, dynamic>> myUsersList =
          myNotices.docs.map((doc) => doc.data()).toList();

      for (var element in myUsersList) {
        myJobNotices.add(JobAdModel(
          jobId: element['jobId'],
          belongsToUser: element['belongsToUser'],
          jobName: element['jobName'],
          companyName: element['companyName'],
          jobEmail: element['jobEmail'],
          jobImage: element['jobImage'],
          jobPhone: element['jobPhone'],
          jobLocation: element['jobLocation'],
          jobQualification: element['jobQualification'],
          jobDescription: element['jobDescription'],
          canRemotely: element['canRemotely'],
          arePaid: element['arePaid'],
        ));
      }

      return myJobNotices;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<List<JobAdModel>?> downloadFavJobNotices(
      List<String> favNoticesIds, String userId) async {
    try {
      List<JobAdModel> jobNotices = [];

      CollectionReference collectionRef = _firestore.collection('jobAd');
      for (String element in favNoticesIds) {
        DocumentSnapshot favJob = await collectionRef.doc(element).get();

        if (favJob.data() != null) {
          Map<String, dynamic> docSnapshot =
              favJob.data() as Map<String, dynamic>;

          jobNotices.add(JobAdModel(
            jobId: docSnapshot['jobId'],
            belongsToUser: docSnapshot['belongsToUser'],
            jobName: docSnapshot['jobName'],
            companyName: docSnapshot['companyName'],
            jobEmail: docSnapshot['jobEmail'],
            jobImage: docSnapshot['jobImage'],
            jobPhone: docSnapshot['jobPhone'],
            jobLocation: docSnapshot['jobLocation'],
            jobQualification: docSnapshot['jobQualification'],
            jobDescription: docSnapshot['jobDescription'],
            canRemotely: docSnapshot['canRemotely'],
            arePaid: docSnapshot['arePaid'],
          ));
        } else {
          await _firestore.collection('users').doc(userId).update({
            'likedOffers': FieldValue.arrayRemove([element])
          });
        }
      }

      return jobNotices;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<List<MyUser>?> downloadFavUsersNotices(
      List<String> favNoticesIds, String userId) async {
    try {
      List<MyUser> usersNotices = [];

      CollectionReference collRef = _firestore.collection('users');
      for (String element in favNoticesIds) {
        DocumentSnapshot favJob = await collRef.doc(element).get();

        if (favJob.data() != null) {
          Map<String, dynamic> docSnapshot =
              favJob.data() as Map<String, dynamic>;

          usersNotices.add(MyUser(
              userId: docSnapshot['userId'],
              username: docSnapshot['username'],
              age: docSnapshot['age'],
              description: docSnapshot['description'],
              phoneNum: docSnapshot['phoneNum'],
              location: docSnapshot['location'],
              placeId: docSnapshot['placeId'],
              isAccountTypeUser: docSnapshot['isAccountTypeUser'],
              skillsSet: (docSnapshot['skillsSet'] as List<dynamic>)
                  .map((item) => Map<String, int>.from(item))
                  .toList(),
              email: docSnapshot['email'],
              profilePicture: docSnapshot['profilePicture'],
              likedOffers: List.from(docSnapshot['likedOffers']),
              jobVacancy: docSnapshot['jobVacancy'],
              accountCreated: docSnapshot['accountCreated']));
        } else {
          await _firestore.collection('users').doc(userId).update({
            'likedOffers': FieldValue.arrayRemove([element]),
          });
        }
      }

      return usersNotices;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<bool?> addUserJobNotice(String userId, bool isEagerToWork) async {
    try {
      await _firestore
          .collection('/users')
          .doc(userId)
          .update({'jobVacancy': isEagerToWork});
      return isEagerToWork;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<MyUser?> takeAdOwnersData(ownerId) async {
    try {
      DocumentSnapshot docSnapshot =
          await _firestore.collection('users').doc(ownerId).get();
      Map<String, dynamic> ownerInfo =
          docSnapshot.data() as Map<String, dynamic>;

      MyUser usersList = MyUser(
          userId: ownerInfo['userId'],
          username: ownerInfo['username'],
          age: ownerInfo['age'],
          description: ownerInfo['description'],
          phoneNum: ownerInfo['phoneNum'],
          location: ownerInfo['location'],
          placeId: ownerInfo['placeId'],
          isAccountTypeUser: ownerInfo['isAccountTypeUser'],
          skillsSet: (ownerInfo['skillsSet'] as List<dynamic>)
              .map((item) => Map<String, int>.from(item))
              .toList(),
          email: ownerInfo['email'],
          profilePicture: ownerInfo['profilePicture'],
          likedOffers: List.from(ownerInfo['likedOffers']),
          jobVacancy: ownerInfo['jobVacancy'],
          accountCreated: ownerInfo['accountCreated']);
      return usersList;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

// JOB FUNCTIONS // JOB FUNCTIONS // JOB FUNCTIONS // JOB FUNCTIONS // JOB FUNCTIONS

  Future<void> addFirestoreJobAd(
      String userId,
      File? noticePhoto,
      String jobName,
      String companyName,
      String jobEmail,
      int jobPhone,
      String jobLocation,
      String jobQualification,
      String jobDescription,
      bool canRemotely,
      bool arePaid) async {
    late String jobId;
    String generateRandomCode() {
      const characters = 'abcdefghijklmnopqrstuvwxyz0123456789';

      final randomChars = List.generate(22, (index) {
        final randomIndex = Random().nextInt(characters.length);
        return characters[randomIndex];
      });
      return 'j0bNum${randomChars.join()}';
    }

    jobId = generateRandomCode();

    try {
      String? imageUrl;
      if (noticePhoto != null) {
        final storageReference =
            FirebaseStorage.instance.ref().child('job_ad_pictures/$jobId.jpg');
        await storageReference.putFile(noticePhoto);
        imageUrl = await storageReference.getDownloadURL();
      }
      await _firestore.collection("jobAd").doc(jobId).set({
        'jobId': jobId,
        'belongsToUser': userId,
        'jobImage': imageUrl,
        'jobName': jobName,
        'companyName': companyName,
        'jobEmail': jobEmail,
        'jobPhone': jobPhone,
        'jobLocation': jobLocation,
        'jobQualification': jobQualification,
        'jobDescription': jobDescription,
        'canRemotely': canRemotely,
        'arePaid': arePaid,
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<Map<bool, String?>> updateJob(
      String jobId,
      File? noticePhoto,
      String jobName,
      String companyName,
      String jobEmail,
      int jobPhone,
      String jobLocation,
      String placeId,
      String jobQualification,
      String jobDescription,
      bool canRemotely,
      bool arePaid) async {
    try {
      String? imageUrl;

      if (noticePhoto != null) {
        final storageReference =
            FirebaseStorage.instance.ref().child('job_ad_pictures/$jobId.jpg');
        if (noticePhoto.path != 'fresh') {
          await storageReference.putFile(noticePhoto);
        }

        imageUrl = await storageReference.getDownloadURL();
      }
      await _firestore.collection('jobAd').doc(jobId).update({
        'jobImage': imageUrl,
        'jobName': jobName,
        'companyName': companyName,
        'jobEmail': jobEmail,
        'jobPhone': jobPhone,
        'jobLocation': jobLocation,
        'placeId': placeId,
        'jobQualification': jobQualification,
        'jobDescription': jobDescription,
        'canRemotely': canRemotely,
        'arePaid': arePaid
      });
      return {true: imageUrl};
    } catch (e) {
      debugPrint(e.toString());
      return {false: null};
    }
  }

  Future<bool> deleteJobAdvert(String jobId) async {
    try {
      await _firestore.collection('jobAd').doc(jobId).delete();
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }
}
