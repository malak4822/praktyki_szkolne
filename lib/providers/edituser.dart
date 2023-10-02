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

  bool _areFieldsEmpty = false;
  bool get areFieldsEmpty => _areFieldsEmpty;

  set setSkillBoxes(skillBoxes) {
    _skillBoxes = skillBoxes;
  }

  File? _imgFile;
  File? get imgFile => _imgFile;

  Future<void> getStorageImage() async {
    final imagePicker = ImagePicker();

    final pickedImage = await imagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 12);
    if (pickedImage != null) {
      _imgFile = File(pickedImage.path);

      notifyListeners();
    }
  }

  Future<void> getCameraImage() async {
    final imagePicker = ImagePicker();

    final pickedImage = await imagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 12);

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
    notifyListeners();
  }

  void removeSkillBox() {
    if (_skillBoxes.isNotEmpty) {
      if (_skillBoxes.length != 1) {
        _skillBoxes.removeAt(_currentChosenBox);
        _currentChosenBox = 0;
      } else {
        _skillBoxes.removeLast();
      }
      notifyListeners();
    }
  }

  Future<void> deleteSelectedImage() async {
    if (_imgFile != null) {
      try {
        await _imgFile!.delete();
        _imgFile = null;
        notifyListeners();
      } catch (e) {
        debugPrint('Error deleting image: $e');
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
    _skillBoxes.add({'': 1});
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

  void checkEmptiness(
      String name, String description, int age, String location) {
    if (name.isEmpty || description.isEmpty || age == 0 || location.isEmpty) {
      _areFieldsEmpty = true;
    } else {
      _areFieldsEmpty = false;
    }
    notifyListeners();
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
