import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:prakty/models/advertisements_model.dart';
import 'package:prakty/services/database.dart';
import '../models/user_model.dart';

class GoogleSignInProvider extends ChangeNotifier {
  FirebaseAuth auth = FirebaseAuth.instance;

  final bool _isLiked = false;
  bool get isLiked => _isLiked;

  void toogleOffer(String offerId) {}

  void setState() {
    notifyListeners();
  }

  void toogleAccountType(newType) {
    _loggedUser.isAccountTypeUser = newType;
    notifyListeners();
  }

  void userSearchingToogle(newValue) {
    _loggedUser.jobVacancy = newValue;
    notifyListeners();
  }

  void refreshNameAndDesc(bool isAccountTypeUser, String newUsername,
      String newDescription, String? newLocation, String? newAge) {
    if (isAccountTypeUser) {
      _loggedUser.username = newUsername;
      _loggedUser.description = newDescription;
      _loggedUser.location = newLocation;
      _loggedUser.age = int.parse(newAge!);
    } else {
      _loggedUser.username = newUsername;
      _loggedUser.description = newDescription;
    }
    notifyListeners();
  }

  void refreshContactInfo(String newEmail, String newPhone) {
    _loggedUser.email = newEmail;
    _loggedUser.phoneNum = newPhone;
    notifyListeners();
  }

  List<JobAdModel> _myOffersList = [];
  List<JobAdModel> get myOffersList => _myOffersList;

  set setMyOffersList(List<JobAdModel> newList) => _myOffersList = newList;

  void refreshJobInfo(
      String jobId,
      String pictureToShow,
      String jobName,
      String companyName,
      String jobEmail,
      int jobPhone,
      String jobLocation,
      String jobQualification,
      String jobDescription,
      bool canRemotely) {
    int offerIndex =
        _myOffersList.indexWhere((element) => element.jobId == jobId);

    _myOffersList[offerIndex].jobImage = pictureToShow;
    _myOffersList[offerIndex].jobName = jobName;
    _myOffersList[offerIndex].companyName = companyName;
    _myOffersList[offerIndex].jobEmail = jobEmail;
    _myOffersList[offerIndex].jobPhone = jobPhone;
    _myOffersList[offerIndex].jobLocation = jobLocation;
    _myOffersList[offerIndex].jobQualification = jobQualification;
    _myOffersList[offerIndex].jobDescription = jobDescription;
    _myOffersList[offerIndex].canRemotely = canRemotely;
    notifyListeners();
  }

  void refreshSkillSet(newSkillSet) {
    _loggedUser.skillsSet = newSkillSet;
    notifyListeners();
  }

  void refreshProfilePicture(newPictureUrl) {
    _loggedUser.profilePicture = newPictureUrl;
    notifyListeners();
  }

  MyUser _loggedUser = MyUser(
      userId: '',
      username: '',
      description: null,
      phoneNum: null,
      age: null,
      isAccountTypeUser: true,
      email: '',
      location: null,
      profilePicture: null,
      likedOffers: [],
      jobVacancy: false,
      accountCreated: Timestamp(0, 0),
      skillsSet: []);
  MyUser get getCurrentUser => _loggedUser;

  Future<void> authenticateUser(
      String actualPassword, String newEmail, Function callBack) async {
    User? user = auth.currentUser;
    if (actualPassword.isNotEmpty) {
      if (user != null) {
        try {
          await user.reauthenticateWithCredential(
            EmailAuthProvider.credential(
              email: _loggedUser.email,
              password: actualPassword,
            ),
          );
          callBack(true, '');
        } on FirebaseAuthException catch (errorMsg) {
          if (errorMsg.code == 'invalid-credential' ||
              errorMsg.code == 'wrong-password') {
            callBack(false, 'Proszę Wpisać Poprawnę Hasło');
          } else if (errorMsg.code == 'too-many-requests') {
            callBack(false,
                'Zbyt wiele nieudanych prób logowania, dostęp tymczasowo wyłączony');
          }
        }
      }
    } else {
      callBack(false, 'Proszę Wpisać Hasło');
    }
  }

  // LOG OUT LOG OUT LOG OUT LOG OUT
  Future<void> logout() async {
    try {
      await auth.signOut();
      _loggedUser = MyUser(
          userId: '',
          username: '',
          description: null,
          phoneNum: null,
          age: null,
          isAccountTypeUser: true,
          email: '',
          location: null,
          profilePicture: null,
          likedOffers: [],
          jobVacancy: false,
          skillsSet: [],
          accountCreated: Timestamp(0, 0));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  //GOOGLE LOGIN GOOGLE LOGIN GOOGLE LOGIN GOOGLE LOGIN
  Future<void> loginViaGoogle() async {
    GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: ['email', 'https://www.googleapis.com/auth/contacts.readonly'],
    );

    try {
      GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      GoogleSignInAuthentication googleUserAuth =
          await googleUser!.authentication;
      final AuthCredential credentialTokens = GoogleAuthProvider.credential(
          accessToken: googleUserAuth.accessToken,
          idToken: googleUserAuth.idToken);

      var authResult = await auth.signInWithCredential(credentialTokens);

      if (authResult.additionalUserInfo!.isNewUser) {
        _loggedUser.username = authResult.user!.displayName!;
        _loggedUser.email = authResult.user!.email!;
        _loggedUser.profilePicture = authResult.user!.photoURL!;
        _loggedUser.userId = authResult.user!.uid;

        await MyDb().addFirestoreUser(_loggedUser);
      }
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future<void> setUserOnStart(context) async {
    try {
      if (auth.currentUser != null) {
        await MyDb().getUserInfo(context, auth.currentUser!.uid);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  // EMAIL PASS LOGIN EMAIL PASS LOGIN EMAIL PASS LOGIN EMAIL PASS LOGIN
  Future<void> loginViaEmailAndPassword(String email, String pass) async {
    try {
      UserCredential userCredentials =
          await auth.signInWithEmailAndPassword(email: email, password: pass);

      await MyDb().getUserInfo(_loggedUser, userCredentials.user!.uid);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          _errorMessage = 'invalid-email';
          break;
        case 'too-many-requests':
          _errorMessage = 'too-many-requests';
          break;
        case 'wrong-password':
          _errorMessage = 'wrong-password';
          break;
        case 'user-not-found':
          _errorMessage = 'user-not-found';
          break;
      }
      notifyListeners();
    } catch (e) {
      debugPrint('ERROR TO ----> ${e.toString()}');
    }
  }

  // CREATING USERS CREATING USERS CREATING USERS
  Future<void> signUpViaEmail(
      String email, String password, String username) async {
    try {
      UserCredential authResult = await auth.createUserWithEmailAndPassword(
          email: email, password: password);

      _loggedUser.username = username;
      _loggedUser.email = email;
      _loggedUser.userId = authResult.user!.uid;
      _loggedUser.accountCreated = Timestamp.now();

      await MyDb().addFirestoreUser(_loggedUser);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          _errorMessage = 'email-already-in-use';
          break;
        case 'invalid-email':
          _errorMessage = 'invalid-email';
          break;
        case 'weak-password':
          _errorMessage = 'weak-password';
          break;
      }
    } catch (errorTxt) {
      debugPrint(errorTxt.toString());
    }
  }

  set addNoticeToFav(String noticeId) {
    _loggedUser.likedOffers.add(noticeId);
  }

  set removeNoticeFromFav(String noticeId) {
    _loggedUser.likedOffers.remove(noticeId);
  }
}
