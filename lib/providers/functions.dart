import 'package:flutter/material.dart';

class Functions extends ChangeNotifier {
  double _fillField = 0;
  double get fillFieldLvl => _fillField;

  int _currentIndex = 2;
  int get currentIndex => _currentIndex;

  void changePage(int newIndex) {
    _currentIndex = newIndex;
    notifyListeners();
  }
}
