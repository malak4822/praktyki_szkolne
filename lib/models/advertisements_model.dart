class JobAdModel {
  String jobId;
  String belongsToUser;
  String jobName;
  String companyName;
  String jobEmail;
  String? jobImage;
  int jobPhone;
  String jobLocation;
  String jobQualification;
  String jobDescription;
  bool canRemotely;

  JobAdModel({
    required this.jobId,
    required this.belongsToUser,
    required this.jobName,
    required this.companyName,
    required this.jobEmail,
    required this.jobImage,
    required this.jobPhone,
    required this.jobLocation,
    required this.jobQualification,
    required this.jobDescription,
    required this.canRemotely,
  });
}
