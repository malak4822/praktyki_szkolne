import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../models/user_model.dart';

enum LoggedVia { emailAndPassword, google }

class GoogleSignInProvider extends ChangeNotifier {
  late final MyUser _currentUser;
  FirebaseAuth auth = FirebaseAuth.instance;

  MyUser get getCurrentUser => _currentUser;

  // LOG OUT LOG OUT LOG OUT LOG OUT

  Future<void> logout() async {
    await auth.signOut();
    notifyListeners();
  }

  Future<bool> checkInternetConnectivity() async {
    final customInstance = InternetConnectionChecker.createInstance(
        checkTimeout: const Duration(seconds: 1));
    if (await customInstance.hasConnection == true) {
      return true;
    } else {
      return false;
    }
  }

  String createMessage(errorString) {
    errorString ??=
        "Wygląda Na To, Że Brakuje Ci Połączenia Z Siecią. Masz Na To Może Jakiś Plan B? Bo My Ci Go Nie Załatwimy 😉";
    return errorString;
  }

  bool _showErrorMessage = false;
  bool get showErrorMessage => _showErrorMessage;

  void toogleErrorMessage() {
    _showErrorMessage = !_showErrorMessage;
    notifyListeners();
  }

  // LOGIN LOGIN LOGIN LOGIN LOGIN LOGIN LOGIN LOGIN LOGIN

  void login(String email, String password, LoggedVia loginType) {
    switch (loginType) {
      case LoggedVia.emailAndPassword:
        loginViaEmailAndPassword(email, password);
        print('Loggining with email and password');
        break;
      case LoggedVia.google:
        loginViaGoogle();
        print('Loggining with google');
        break;
    }
  }

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
      print(error);
    }
  }

  Future<void> loginViaEmailAndPassword(String email, String pass) async {
    if (await checkInternetConnectivity() == false) {
      createMessage(null);
      toogleErrorMessage();
    } else {
      try {
        UserCredential userCredentials =
            await auth.signInWithEmailAndPassword(email: email, password: pass);
        if (userCredentials.user != null) {
          _currentUser.userId = userCredentials.user!.uid;
          _currentUser.email = userCredentials.user!.email!;
        }
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }

  // CREATING USERS CREATING USERS CREATING USERS
  Future<void> createUser(String email, String password) async {
    _isEmailEmpty = false;
    _isPasswdEmpty = false;
    _isEmailValidErrorShown = false;
    _isEmailExists = false;
    _isPassErrorShown = false;
    notifyListeners();

    if (email == '') {
      showEmailIsEmptyError();
    } else if (password == '') {
      showPassIsEmptyError();
    } else
    if (await checkInternetConnectivity() == false) {
      createMessage(null);
      toogleErrorMessage();
    } else {
      try {
        await auth.createUserWithEmailAndPassword(
            email: email, password: password);
      } on FirebaseAuthException catch (e) {
        switch (e.code) {
          case 'email-already-in-use':
            showEmailExistExistError();
            break;
          case 'invalid-email':
            showEmailIsInvalidError();
            break;
          case 'weak-password':
            switchPassErrorVisibility();
            break;
        }
      } catch (errorTxt) {
        createMessage(errorTxt);
        toogleErrorMessage();
      }
    }
  }

  // CHECKING IF DATA ARE CORRECT  CHECKING IF DATA ARE CORRECT  CHECKING IF DATA ARE CORRECT

  bool _isEmailEmpty = false;
  bool get isEmailEmpty => _isEmailEmpty;

  bool _isPasswdEmpty = false;
  bool get isPasswdEmpty => _isPasswdEmpty;

  bool _isEmailValidErrorShown = false;
  bool get isEmailValidErrorShown => _isEmailValidErrorShown;

  bool _isEmailExists = false;
  bool get isEmailExists => _isEmailExists;

  bool _isPassErrorShown = false;
  bool get isPassErrorShown => _isPassErrorShown;

  void showEmailExistExistError() {
    _isEmailExists = true;
    notifyListeners();
  }

  void showEmailIsEmptyError() {
    _isEmailEmpty = true;
    notifyListeners();
  }

  void showPassIsEmptyError() {
    _isPasswdEmpty = true;
    notifyListeners();
  }

  void showEmailIsInvalidError() {
    _isEmailValidErrorShown = true;
    notifyListeners();
  }

  void switchPassErrorVisibility() {
    _isPassErrorShown = true;
    notifyListeners();
  }
}
