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

  void refresh(newUsername, newDescription) {
    _currentUser.username = newUsername;
    _currentUser.description = newDescription;
    notifyListeners();
  }

  MyUser _currentUser = MyUser(
      userId: '',
      username: '',
      description: '',
      age: 0,
      isNormalUser: false,
      email: '',
      profilePicture: '',
      registeredViaGoogle: false,
      accountCreated: Timestamp(0, 0),
      skillsSet: []);
  MyUser get getCurrentUser => _currentUser;

  final List<String> _usersId = [];

  Future<void> getUsersIds() async {
    final userCollection =
        await FirebaseFirestore.instance.collection('users/').get();
    for (var element in userCollection.docs) {
      _usersId.add(element.reference.id);
    }
  }

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

  //
  // EMAIL PASS LOGIN EMAIL PASS LOGIN EMAIL PASS LOGIN EMAIL PASS LOGIN
  Future<void> loginViaEmailAndPassword(
      String email, String pass, context) async {
    var loginConstrAccess =
        Provider.of<LoginConstrains>(context, listen: false);
    if (await loginConstrAccess.checkInternetConnectivity() == true) {
      if (loginConstrAccess.isEmailAndPassEmpty(email, pass) == false) {
        try {
          UserCredential userCredentials = await auth
              .signInWithEmailAndPassword(email: email, password: pass);
          await MyDb().getUserInfo(_currentUser, userCredentials.user!.uid);
          notifyListeners();
        } on FirebaseAuthException catch (e) {
          switch (e.code) {
            case 'invalid-email':
              loginConstrAccess.showEmailIsInvalidError();
              break;
            case 'wrong-password':
              loginConstrAccess.showWrongPasswordError();
              break;
            case 'user-not-found':
              loginConstrAccess.showUserNotFoundError();
              break;
            case 'weak-password':
              loginConstrAccess.switchPassErrorVisibility();
              break;
          }
        } catch (e) {
          print(e.toString());
          // loginConstrAccess.showErrorBox(e.toString());
        }
      }
    }
  }

  //
  // CREATING USERS CREATING USERS CREATING USERS
  Future<void> signUpViaEmail(
      String email, String password, String username, context) async {
    var loginConstrAccess =
        Provider.of<LoginConstrains>(context, listen: false);

    if (await loginConstrAccess.checkInternetConnectivity() == true) {
      if (username.trim().length < 4) {
        loginConstrAccess.showUsernameTooShortError();
      } else if (username.trim().length > 22) {
        loginConstrAccess.showUsernameTooLongError();
      } else {
        if (loginConstrAccess.isEmailAndPassEmpty(email, password) == false) {
          try {
            UserCredential authResult =
                await auth.createUserWithEmailAndPassword(
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
                loginConstrAccess.showEmailExistError();
                break;
              case 'invalid-email':
                loginConstrAccess.showEmailIsInvalidError();
                break;
              case 'weak-password':
                loginConstrAccess.switchPassErrorVisibility();
                break;
            }
          } catch (errorTxt) {
            loginConstrAccess.showErrorBox(errorTxt);
          }
        }
      }
    }
  }
}
