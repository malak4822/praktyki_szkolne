import 'package:cloud_firestore/cloud_firestore.dart';

class MyUser {
  String userId;
  String username;
  //
  String description;
  int age;
  bool isNormalUser;
  Map<String, int> skillsSet;
  //
  String email;
  String profilePicture;
  late bool registeredViaGoogle;
  late Timestamp accountCreated;

  MyUser({
    required this.userId,
    required this.username,
    required this.age,
    required this.isNormalUser,
    required this.description,
    required this.skillsSet,
    required this.email,
    required this.profilePicture,
    required this.registeredViaGoogle,
    required this.accountCreated,
  });
}
