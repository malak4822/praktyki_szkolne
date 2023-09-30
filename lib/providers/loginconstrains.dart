import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class LoginConstrains extends ChangeNotifier {
  Future<bool> checkInternetConnectivity() async {
    final customInstance = InternetConnectionChecker.createInstance(
        checkTimeout: const Duration(seconds: 1));
    if (await customInstance.hasConnection == true) {
      _showErrorMessage = false;
      notifyListeners();
      return true;
    } else {
      showErrorBox(
          "Wygląda Na To, Że Brakuje Ci Internetu. Masz Na To Może Jakiś Plan B? 😉");
      return false;
    }
  }

  bool _isPasswdEmpty = false;
  bool get isPasswdEmpty => _isPasswdEmpty;

  bool _isEmailEmpty = false;
  bool get isEmailEmpty => _isEmailEmpty;

  bool _isPasswordWrong = false;
  bool get isPasswordWrong => _isPasswordWrong;

  bool _isUserFound = false;
  bool get isUserFound => _isUserFound;

  bool _isEmailValidErrorShown = false;
  bool get isEmailValidErrorShown => _isEmailValidErrorShown;

  bool _doEmailExist = false;
  bool get doEmailExist => _doEmailExist;

  bool _isPassErrorShown = false;
  bool get isPassErrorShown => _isPassErrorShown;

  bool _isUsernameTooLong = false;
  bool get isUsernameTooLong => _isUsernameTooLong;

  bool _isUsernameTooShort = false;
  bool get isUsernameTooShort => _isUsernameTooShort;

  bool _showErrorMessage = false;
  bool get showErrorMessage => _showErrorMessage;

  late String _errorText;
  String get errorText => _errorText;

  void showUsernameTooShortError() {
    _isUsernameTooShort = true;
    notifyListeners();
  }

  void showUsernameTooLongError() {
    _isUsernameTooLong = true;
    notifyListeners();
  }

  void showEmailExistError() {
    _doEmailExist = true;
    notifyListeners();
  }

  void showWrongPasswordError() {
    _isPasswordWrong = true;
    notifyListeners();
  }

  void showUserNotFoundError() {
    _isUserFound = true;
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

  void clearWarnings() {
    _isUsernameTooShort = false;
    _isUsernameTooLong = false;
    _isUserFound = false;
    _isPasswordWrong = false;
    _isEmailEmpty = false;
    _isPasswdEmpty = false;
    _isEmailValidErrorShown = false;
    _doEmailExist = false;
    _isPassErrorShown = false;
    notifyListeners();
  }

  void showErrorBox(errorString) {
    _errorText = errorString;
    _showErrorMessage = true;
    notifyListeners();
  }

  void closeErrorBox() {
    _showErrorMessage = false;
    notifyListeners();
  }
}
