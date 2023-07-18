import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GoogleSignInProvider extends ChangeNotifier {
  FirebaseAuth auth = FirebaseAuth.instance;

  // LOG OUT LOG OUT LOG OUT LOG OUT

  Future<void> logout() async {
    await auth.signOut();
    notifyListeners();
  }

  // CREATING USERS CREATING USERS CREATING USERS

  String _username = 'Username';
  String get username => _username;

  void createName(newName) {
    _username = newName;
    notifyListeners();
  }

  Future<void> createUser(email, password) async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        // KONTO Z TYM EMAILEM JUŻ ISTNIEJE
        clearValidations();
        showEmailExistExistError();
      } else if (e.code == 'invalid-email') {
        // EMAIL JEST NIE POPRAWNY
        clearValidations();
        showEmailIsInvalidError();
        notifyListeners();
      } else if (e.code == 'weak-password') {
        // HASŁO JEST ZBYT SŁABE
        clearValidations();
        switchPassErrorVisibility();
        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }

  // CHECKING IF DATA ARE CORRECT  CHECKING IF DATA ARE CORRECT  CHECKING IF DATA ARE CORRECT

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

  void showEmailIsInvalidError() {
    _isEmailValidErrorShown = true;
    notifyListeners();
  }

  void clearValidations() {
    _isEmailValidErrorShown = false;
    _isEmailExists = false;
    _isPassErrorShown = false;
    notifyListeners();
  }

  void switchPassErrorVisibility() {
    _isPassErrorShown = true;
    notifyListeners();
  }
}
