import 'package:flutter/material.dart';
import 'package:prakty/models/advertisements_model.dart';

class JobAd extends ChangeNotifier {
  JobAdModel _jobAdvertisement = JobAdModel(
    jobId: '',
    belongsToUser: '',
    jobName: '',
    companyName: '',
    jobEmail: '',
    jobImage: '',
    jobPhone: 0,
    jobLocation: '',
    jobQualification: '',
    jobDescription: '',
    canRemotely: false,
  );

  JobAdModel get jobAdvertisement => _jobAdvertisement;
}
