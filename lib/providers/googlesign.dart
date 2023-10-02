import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:prakty/providers/loginconstrains.dart';
import 'package:prakty/services/database.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';

class GoogleSignInProvider extends ChangeNotifier {
  FirebaseAuth auth = FirebaseAuth.instance;

  void refreshNameAndDesc(newUsername, newDescription, newLocation, newAge) {
    _currentUser.username = newUsername;
    _currentUser.description = newDescription;
    _currentUser.location = newLocation;
    _currentUser.age = newAge;
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
      description: '',
      age: 0,
      isNormalUser: false,
      email: '',
      location: '',
      profilePicture: '',
      registeredViaGoogle: false,
      accountCreated: Timestamp(0, 0),
      skillsSet: []);
  MyUser get getCurrentUser => _currentUser;

  // LOG OUT LOG OUT LOG OUT LOG OUT
  Future<void> logout() async {
    try {
      await auth.signOut();
      _currentUser = MyUser(
          userId: '',
          username: '',
          description: '',
          age: 0,
          isNormalUser: false,
          email: '',
          location: '',
          profilePicture: '',
          registeredViaGoogle: false,
          skillsSet: [],
          accountCreated: Timestamp(0, 0));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  //GOOGLE LOGIN GOOGLE LOGIN GOOGLE LOGIN GOOGLE LOGIN
  Future<void> loginViaGoogle(context) async {
    GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: ['email', 'https://www.googleapis.com/auth/contacts.readonly'],
    );
    if (await Provider.of<LoginConstrains>(context, listen: false)
            .checkInternetConnectivity() ==
        true) {
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
          _currentUser.registeredViaGoogle = true;
          await MyDb().addFirestoreUser(_currentUser);
        }
        await MyDb().getUserInfo(context, authResult.user!.uid);
      } catch (error) {
        debugPrint(error.toString());
      }
    }
  }

  void setUserOnStart(context) async {
    try {
      if (auth.currentUser != null) {
        await MyDb().getUserInfo(context, auth.currentUser!.uid);
      }
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  // EMAIL PASS LOGIN EMAIL PASS LOGIN EMAIL PASS LOGIN EMAIL PASS LOGIN
  Future<void> loginViaEmailAndPassword(String email, String pass) async {
    try {
      // _errorMessage = '';

      UserCredential userCredentials =
          await auth.signInWithEmailAndPassword(email: email, password: pass);
      await MyDb().getUserInfo(_currentUser, userCredentials.user!.uid);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          print('email jest zły');
          _errorMessage = 'invalid-email';
          notifyListeners();
          break;
        case 'wrong-password':
          print('zle haslo');
          _errorMessage = 'wrong-password';
          notifyListeners();
          break;
        case 'user-not-found':
          print('nie ma takiego uzytkownika');
          _errorMessage = 'user-not-found';
        notifyListeners();
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
      _currentUser.registeredViaGoogle = false;
      _currentUser.userId = authResult.user!.uid;
      _currentUser.accountCreated = Timestamp.now();
      await MyDb().addFirestoreUser(_currentUser);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          break;
        case 'invalid-email':
          break;
        case 'weak-password':
          break;
      }
    } catch (errorTxt) {
      debugPrint(errorTxt.toString());
    }
  }
}
