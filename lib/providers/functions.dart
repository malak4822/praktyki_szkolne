import 'package:flutter/material.dart';

class Functions extends ChangeNotifier {
  double _fillField = 0;
  double get fillFieldLvl => _fillField;

  void lvlUp(boxWidth) {
    _fillField = _fillField + boxWidth / 6;
    notifyListeners();
  }

  int _currentIndex = 2;
  int get currentIndex => _currentIndex;

  void changePage(int newIndex) {
    _currentIndex = newIndex;
    notifyListeners();
  }

  
}
