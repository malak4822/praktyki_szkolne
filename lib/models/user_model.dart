import 'package:cloud_firestore/cloud_firestore.dart';

class MyUser {
  String userId;
  String username;
  //
  String description;
  String location;
  int age;
  bool isNormalUser;
  List<Map<String, int>> skillsSet;
  //
  String email;
  String profilePicture;
  late bool registeredViaGoogle;
  late Timestamp accountCreated;

  MyUser({
    required this.userId,
    required this.username,
    required this.age,
    required this.location,
    required this.isNormalUser,
    required this.description,
    required this.skillsSet,
    required this.email,
    required this.profilePicture,
    required this.registeredViaGoogle,
    required this.accountCreated,
  });
}

class JobAd {
  //  jobName, companyName, jobEmail, jobPhone,
  // jobLocation, jobQualification, jobDescription, canRemotely
  String jobName;
  String companyName;
  String jobEmail;
  int jobPhone;
  String jobLocation;
  String jobQualification;
  String jobDescription;
  bool canRemotely;
  //

  JobAd({
    required this.jobName,
    required this.companyName,
    required this.jobEmail,
    required this.jobPhone,
    required this.jobLocation,
    required this.jobQualification,
    required this.jobDescription,
    required this.canRemotely,
  });
}
