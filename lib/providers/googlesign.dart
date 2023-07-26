import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:prakty/providers/loginconstrains.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';

enum LoggedVia { emailAndPassword, google }

class GoogleSignInProvider extends ChangeNotifier {
  FirebaseAuth auth = FirebaseAuth.instance;

  final MyUser _currentUser = MyUser(
      userId: 'userId',
      username: 'username',
      email: 'email',
      profilePicture: 'profilePicture');
  MyUser get getCurrentUser => _currentUser;

  final List<String> _usersId = [];
  get usersId => _usersId;

  Future<void> getUsersIds() async {
    final userCollection =
        await FirebaseFirestore.instance.collection('users/').get();
    for (var element in userCollection.docs) {
      _usersId.add(element.reference.id);
    }
  }

  // LOGOWANIE WYLOGOWYWANIE REJESTROWANIE LOGOWANIE WYLOGOWYWANIE REJESTROWANIE
  //
  // LOG OUT LOG OUT LOG OUT LOG OUT
  Future<void> logout() async {
    await auth.signOut();
    notifyListeners();
  }

  //
  // LOGIN DESICION LOGIN DESICION LOGIN DESICION LOGIN DESICION
  void loginDesicion(
      String email, String password, LoggedVia loginType, context) async {
    var loginConstrAccess =
        Provider.of<LoginConstrains>(context, listen: false);

    if (await loginConstrAccess.checkInternetConnectivity() == true) {
      switch (loginType) {
        case LoggedVia.emailAndPassword:
          loginViaEmailAndPassword(email, password, context);
          break;
        case LoggedVia.google:
          loginViaGoogle();
          break;
      }
    }
  }

  //
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

      await auth.signInWithCredential(credentialTokens);
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  //
  // EMAIL PASS LOGIN EMAIL PASS LOGIN EMAIL PASS LOGIN EMAIL PASS LOGIN
  Future<void> loginViaEmailAndPassword(
      String email, String pass, BuildContext context) async {
    var loginConstrAccess =
        Provider.of<LoginConstrains>(context, listen: false);
    if (loginConstrAccess.isEmailAndPassEmpty(email, pass) == false) {
      try {
        UserCredential userCredentials =
            await auth.signInWithEmailAndPassword(email: email, password: pass);
        if (userCredentials.user != null) {
          _currentUser.userId = userCredentials.user!.uid;
          _currentUser.email = userCredentials.user!.email!;
        }
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
        loginConstrAccess.showErrorBox(e);
      }
    }
  }

  //
  // CREATING USERS CREATING USERS CREATING USERS
  Future<void> createUser(
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
            await auth.createUserWithEmailAndPassword(
                email: email, password: password);
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
