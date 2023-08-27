import 'package:flutter/material.dart';

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

  List<Map<String, int>> _skillBoxes = [];
  List<Map<String, int>> get skillBoxes => _skillBoxes;

  List<Map<String, int>> _skillBoxesBackup = [];
  List<Map<String, int>> get skillBoxesBackup => _skillBoxesBackup;

  set doSkillBoxesBackup(backup) {
    _skillBoxesBackup = backup;
  }

  set restoreSkillBoxes(currentBoxes) {
    _skillBoxesBackup = currentBoxes;
  }

  int _tabToOpen = 1;
  int get tabToOpen => _tabToOpen;

  // int _currentBoxIndex = 1;
  // int get currentBoxIndex => _currentBoxIndex;

  void addSkillLvl() {
    int dotsNumber = skillBoxes[currentChosenBox].values.single;
    String key = skillBoxes[currentChosenBox].keys.single;
    if (dotsNumber == 5) {
      skillBoxes[currentChosenBox][key] = 1;
    } else {
      skillBoxes[currentChosenBox][key] = dotsNumber + 1;
    }
    notifyListeners();
  }

  void changeSkillTxt() {
    int key = skillBoxes[currentChosenBox].values.single;

    // skillBoxes[currentChosenBox][key] = '1';
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
