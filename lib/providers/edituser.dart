import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditUser extends ChangeNotifier {
  int _currentChosenBox = 1;
  int get currentChosenBox => _currentChosenBox;

  bool _isDescOrNameEmpty = false;
  bool get isDescOrNameEmpty => _isDescOrNameEmpty;

  void setEmptiness(bool newValue) {
    _isDescOrNameEmpty = newValue;
    notifyListeners();
  }

  void checkEmptiness(name, description) {
    if (name || description) {
      setEmptiness(true);
    } else {
      setEmptiness(false);
    }
  }

  void changeCurrentBox(newIndexBox) {
    _currentChosenBox = newIndexBox;
    notifyListeners();
  }

  List<Map<String, int>> skillBoxes = [
    {"HTML": 2},
    {"CSS": 3},
    {"Flutter": 5},
    {"Javascript": 2}
  ];

  int _tabToOpen = 1;
  int get tabToOpen => _tabToOpen;

  // int _currentBoxIndex = 1;
  // int get currentBoxIndex => _currentBoxIndex;

  void getSkillLvl() {
    int dotsNumber = skillBoxes[currentChosenBox].values.single;
    String key = skillBoxes[currentChosenBox].keys.single;
    if (dotsNumber == 5) {
      skillBoxes[currentChosenBox][key] = 1;
    } else {
      skillBoxes[currentChosenBox][key] = dotsNumber + 1;
    }
    notifyListeners();
  }

  void addSkillBox() {
    skillBoxes.add({'Skill': 1});
    notifyListeners();
  }

  bool _isEditingSeen = false;
  bool get isEditingSeen => _isEditingSeen;

  void toogleEditingPopUp(index) {
    _tabToOpen = index;
    _isEditingSeen = !_isEditingSeen;
    notifyListeners();
  }
}
