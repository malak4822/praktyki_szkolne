import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class EditUser extends ChangeNotifier {
  void toogleAddToFav(String userId) {
    _favList.contains(userId) ? _favList.remove(userId) : _favList.add(userId);
    notifyListeners();
  }

  void initialFileSet() => _imgFile = File('fresh');

  set setpictureToShow(currentImage) {
    if (currentImage != null) {
      _pictureToShow = NetworkImage(currentImage);
    } else {
      _pictureToShow = null;
      notifyListeners();
    }
  }

  List<String> _favList = [];
  List<String> get favList => _favList;

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
    _skillBoxesBackup = skillBoxes;
  }

  ImageProvider<Object>? _pictureToShow;
  ImageProvider<Object>? get pictureToShow => _pictureToShow;

  File? _imgFile;
  File? get imgFile => _imgFile;

  void removeImage() {
    _pictureToShow = null;
    notifyListeners();
  }

  Future<void> getStorageImage() async {
    final imagePicker = ImagePicker();

    final pickedImage = await imagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 12);
    if (pickedImage != null) {
      final imgFile = File(pickedImage.path);
      _pictureToShow = FileImage(imgFile);
      _imgFile = imgFile;

      notifyListeners();
    }
  }

  Future<void> getCameraImage() async {
    final imagePicker = ImagePicker();

    final XFile? pickedImage = await imagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 12);

    if (pickedImage != null) {
      final imgFile = File(pickedImage.path);
      _pictureToShow = FileImage(imgFile);
      _imgFile = imgFile;

      notifyListeners();
    }
  }

  void saveSkillBackup(List<Map<String, int>> dbSkillSet) {
    _skillBoxesBackup = dbSkillSet.map((mapElement) {
      return Map<String, int>.from(mapElement);
    }).toList();
  }

  void removeSkillBox() {
    if (_skillBoxesBackup.isNotEmpty) {
      if (_skillBoxesBackup.length != 1) {
        _skillBoxesBackup.removeAt(_currentChosenBox);
        _currentChosenBox = 0;
      } else {
        _skillBoxesBackup.removeLast();
      }
      notifyListeners();
    }
  }

  Future<void> deleteSelectedImage() async {
    try {
      await _imgFile?.delete();
      _imgFile = null;
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting image: $e');
    }
  }

  void addSkillLvl() {
    int dotsNumber = _skillBoxesBackup[currentChosenBox].values.single;
    String key = _skillBoxesBackup[currentChosenBox].keys.single;
    if (dotsNumber == 5) {
      _skillBoxesBackup[currentChosenBox][key] = 1;
    } else {
      _skillBoxesBackup[currentChosenBox][key] = dotsNumber + 1;
    }
    notifyListeners();
  }

  void addSkillBox() {
    _skillBoxesBackup.add({'': 1});
    notifyListeners();
  }

  List<Map<String, int>> _skillBoxesBackup = [];
  List<Map<String, int>> get skillBoxes => _skillBoxesBackup;

  int _tabToOpen = 1;
  int get tabToOpen => _tabToOpen;

  void modifyMapElement(Map<String, int> inputMap, String newText, int newLvl) {
    Map<String, int> modifiedMap = {};

    inputMap.forEach((key, newValue) {
      String modifiedKey = newText;
      int modifiedValue = newValue;

      modifiedMap[modifiedKey] = modifiedValue;
      _skillBoxesBackup[currentChosenBox] = modifiedMap;
    });
    notifyListeners();
  }

  bool _isEditingSeen = false;
  bool get isEditingSeen => _isEditingSeen;

  void checkEmptiness(
      String name, String? description, int? age, String? location) {
    if (name.isEmpty ||
        description == null ||
        age == null ||
        location == null) {
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

  Future<bool> checkInternetConnectivity() async {
    final customInstance = InternetConnectionChecker.createInstance(
        checkTimeout: const Duration(seconds: 1));
    if (await customInstance.hasConnection == true) {
      _showErrorMessage = false;
      return true;
    } else {
      showErrorBox(
          "Wygląda Na To, Że Brakuje Ci Internetu. Masz Na To Może Jakiś Plan B? 😉");
      return false;
    }
  }

  bool _showErrorMessage = false;
  bool get showErrorMessage => _showErrorMessage;

  late String _errorText;
  String get errorText => _errorText;

  void showErrorBox(errorString) {
    _errorText = errorString;
    _showErrorMessage = true;
    notifyListeners();
  }

  void closeErrorBox() {
    _showErrorMessage = false;
    notifyListeners();
  }
}
