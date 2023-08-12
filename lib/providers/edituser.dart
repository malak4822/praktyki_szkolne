import 'package:flutter/material.dart';

class EditUser extends ChangeNotifier {
  int _skillBoxAdeed = 1;
  int get skillBoxAdeed => _skillBoxAdeed;

  void addSkillBox() {
    _skillBoxAdeed = _skillBoxAdeed + 1;
    notifyListeners();
  }

  bool _isEditingSeen = false;
  bool get isEditingSeen => _isEditingSeen;

  void toogleEditingPopUp() {
    _isEditingSeen = !_isEditingSeen;
    notifyListeners();
  }
}
