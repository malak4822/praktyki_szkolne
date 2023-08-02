import 'package:flutter/material.dart';

class Functions extends ChangeNotifier {
  int _currentIndex = 2;
  int get currentIndex => _currentIndex;

  void changePage(int newIndex) {
    _currentIndex = newIndex;
    notifyListeners();
  }
}
