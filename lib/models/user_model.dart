import 'package:cloud_firestore/cloud_firestore.dart';

class MyUser {
  String userId;
  String username;
  String description;
  String email;
  String profilePicture;
  late bool registeredViaGoogle;
  late Timestamp accountCreated;

  MyUser({
    required this.userId,
    required this.username,
    required this.description,
    required this.email,
    required this.profilePicture,
    required this.registeredViaGoogle,
    required this.accountCreated,
  });
}
