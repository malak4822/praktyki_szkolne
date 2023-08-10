import 'package:flutter/material.dart';

class EditUser extends ChangeNotifier {
  bool _isEditingSeen = false;
  bool get isEditingSeen => _isEditingSeen;

  void toogleEditingPopUp(index) {
    _isEditingSeen = !_isEditingSeen;
    notifyListeners();
  }
}
