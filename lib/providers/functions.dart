import 'package:flutter/material.dart';

class Functions extends ChangeNotifier {
  double _fillField = 0;
  double get fillFieldLvl => _fillField;
  bool ee = false;
  bool get aa => ee;

  void lvlUp(boxWidth) {
    if (_fillField == boxWidth) {
      ee = true;
    } else {
      _fillField = _fillField + boxWidth / 6;
    }
    notifyListeners();
  }

  int _currentIndex = 2;
  int get currentIndex => _currentIndex;

  void changePage(int newIndex) {
    _currentIndex = newIndex;
    notifyListeners();
  }
}
