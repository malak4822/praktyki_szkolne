import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditUser extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void changeLoading() {
    _isLoading = !_isLoading;
    notifyListeners();
  }

  int _currentChosenBox = 1;
  int get currentChosenBox => _currentChosenBox;

  bool _isDescOrNameEmpty = false;
  bool get isDescOrNameEmpty => _isDescOrNameEmpty;

  set setSkillBoxes(skillBoxes) {
    _skillBoxes = skillBoxes;
  }

  File? _imgFile;
  File? get imgFile => _imgFile;

  // Function to open the image picker dialog
  Future<void> getImage() async {
    final imagePicker = ImagePicker();

    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      _imgFile = File(pickedImage.path);
      notifyListeners();
    }
  }

  void saveSkillBackup() {
    _skillBoxesBackup = _skillBoxes.map((mapElement) {
      return Map<String, int>.from(mapElement);
    }).toList();
  }

  void restoreSkillBoxData() {
    _skillBoxes = _skillBoxesBackup.map((mapElement) {
      return Map<String, int>.from(mapElement);
    }).toList();
    print(_skillBoxes);
    notifyListeners();
  }

  void removeSkillBox() {
    if (_skillBoxes.length != 1) {
      _skillBoxes.removeAt(_currentChosenBox);
      _currentChosenBox = 0;
    } else {
      print('removed last box');
      _skillBoxes.removeLast();
    }
    notifyListeners();
  }

  Future<void> deleteSelectedImage() async {
    if (_imgFile != null) {
      try {
        await _imgFile!.delete();
        _imgFile = null;
        notifyListeners();
        print('Image deleted successfully.');
      } catch (e) {
        print('Error deleting image: $e');
      }
    }
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

  List<Map<String, int>> _skillBoxes = [];
  List<Map<String, int>> get skillBoxes => _skillBoxes;

  List<Map<String, int>> _skillBoxesBackup = [];
  List<Map<String, int>> get skillBoxesBackup => _skillBoxesBackup;

  int _tabToOpen = 1;
  int get tabToOpen => _tabToOpen;

  void modifyMapElement(Map<String, int> inputMap, String newText, int newLvl) {
    Map<String, int> modifiedMap = {};

    inputMap.forEach((key, newValue) {
      String modifiedKey = newText;
      int modifiedValue = newValue;

      modifiedMap[modifiedKey] = modifiedValue;
      _skillBoxes[currentChosenBox] = modifiedMap;
    });
    notifyListeners();
  }

  bool _isEditingSeen = false;
  bool get isEditingSeen => _isEditingSeen;
  
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

  void toogleEditingPopUp(index) {
    _tabToOpen = index;
    _isEditingSeen = !_isEditingSeen;
    notifyListeners();
  }
}
