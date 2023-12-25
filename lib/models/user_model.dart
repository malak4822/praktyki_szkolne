import 'package:cloud_firestore/cloud_firestore.dart';

class MyUser {
  String userId;
  String username;
  String? description;
  String? phoneNum;
  String? location;
  int? age;
  bool isAccountTypeUser;
  List<Map<String, int>> skillsSet;
  List<String> likedOffers;
  String email;
  String? profilePicture;
  late bool jobVacancy;
  late Timestamp accountCreated;

  MyUser({
    required this.userId,
    required this.username,
    required this.age,
    required this.description,
    required this.phoneNum,
    required this.location,
    required this.isAccountTypeUser,
    required this.skillsSet,
    required this.likedOffers,
    required this.email,
    required this.profilePicture,
    required this.jobVacancy,
    required this.accountCreated,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'username': username,
      'description': description,
      'phoneNum': phoneNum,
      'location': location,
      'age': age,
      'isAccountTypeUser': isAccountTypeUser,
      'skillsSet': skillsSet,
      'email': email,
      'profilePicture': profilePicture,
      'likedOffers': likedOffers,
      'jobVacancy': jobVacancy,
      'accountCreated': accountCreated,
    };
  }
}
