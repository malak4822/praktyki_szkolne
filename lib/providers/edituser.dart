import 'package:flutter/material.dart';

class EditUser extends ChangeNotifier {
  final TextEditingController _skillCont = TextEditingController(text: 'Skill');
  TextEditingController get skillCont => _skillCont;

  int _currentChosenBox = 1;
  int get currentChosenBox => _currentChosenBox;

  bool _isDescOrNameEmpty = false;
  bool get isDescOrNameEmpty => _isDescOrNameEmpty;

  void saveBackup() {
    _skillBoxesBackup = _skillBoxes.map((mapElement) {
      return Map<String, int>.from(mapElement);
    }).toList();
  }

  void restoreSkillBoxData() {
    _skillBoxes = _skillBoxesBackup.map((mapElement) {
      return Map<String, int>.from(mapElement);
    }).toList();
    notifyListeners();
  }

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

  int _tabToOpen = 1;
  int get tabToOpen => _tabToOpen;

  Map<String, int> modifyMapElement(
      Map<String, int> inputMap, String newText, int newLvl) {
    Map<String, int> modifiedMap = {};

    inputMap.forEach((key, newValue) {
      String modifiedKey = newText;
      int modifiedValue = newValue;

      // Add the modified key-value pair to the new map
      modifiedMap[modifiedKey] = modifiedValue;
    });

    return modifiedMap;
  }

  void addSkillLvl() {
    int dotsNumber = _skillBoxes[currentChosenBox].values.single;
    String key = _skillBoxes[currentChosenBox].keys.single;
    if (dotsNumber == 5) {
      _skillBoxes[currentChosenBox][key] = 1;
    } else {
      _skillBoxes[currentChosenBox][key] = dotsNumber + 1;
    }
    notifyListeners();
  }

  void addSkillBox() {
    _skillBoxes.add({'Skill': 1});
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
