import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
    _currentUser.isAccountTypeUser = newType;
    notifyListeners();
  }

  void userSearchingToogle(newValue) {
    _currentUser.jobVacancy = newValue;
    notifyListeners();
  }

  void refreshNameAndDesc(bool isAccountTypeUser, String newUsername,
      String newDescription, String? newLocation, String? newAge) {
    if (isAccountTypeUser) {
      _currentUser.username = newUsername;
      _currentUser.description = newDescription;
      _currentUser.location = newLocation;
      _currentUser.age = int.parse(newAge!);
    } else {
      _currentUser.username = newUsername;
      _currentUser.description = newDescription;
    }
    notifyListeners();
  }

  void refreshContactInfo(String newEmail, String newPhone) {
    _currentUser.email = newEmail;
    _currentUser.phoneNum = newPhone;
    notifyListeners();
  }

  void refreshSkillSet(newSkillSet) {
    _currentUser.skillsSet = newSkillSet;
    notifyListeners();
  }

  void refreshProfilePicture(newPictureUrl) {
    _currentUser.profilePicture = newPictureUrl;
    notifyListeners();
  }

  MyUser _currentUser = MyUser(
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
  MyUser get getCurrentUser => _currentUser;

  Future<void> authenticateUser(
      String actualPassword, String newEmail, Function callBack) async {
    User? user = auth.currentUser;
    if (actualPassword.isNotEmpty) {
      if (user != null) {
        try {
          await user.reauthenticateWithCredential(
            EmailAuthProvider.credential(
              email: _currentUser.email,
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
      _currentUser = MyUser(
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
        _currentUser.username = authResult.user!.displayName!;
        _currentUser.email = authResult.user!.email!;
        _currentUser.profilePicture = authResult.user!.photoURL!;
        _currentUser.userId = authResult.user!.uid;

        await MyDb().addFirestoreUser(_currentUser);
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

      await MyDb().getUserInfo(_currentUser, userCredentials.user!.uid);
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

      _currentUser.username = username;
      _currentUser.email = email;
      _currentUser.userId = authResult.user!.uid;
      _currentUser.accountCreated = Timestamp.now();
      await MyDb().addFirestoreUser(_currentUser);
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
    _currentUser.likedOffers.add(noticeId);
  }

  set removeNoticeFromFav(String noticeId) {
    _currentUser.likedOffers.remove(noticeId);
  }
}
