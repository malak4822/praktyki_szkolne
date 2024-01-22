import 'package:flutter/material.dart';
import 'package:prakty/models/advertisements_model.dart';

class EditJobProvider extends ChangeNotifier {
  JobAdModel _currentJob = JobAdModel(
      jobId: 'jobId',
      belongsToUser: 'essa',
      jobName: '',
      companyName: '',
      jobEmail: '',
      jobImage: '',
      jobPhone: 0,
      jobLocation: '',
      jobQualification: '',
      jobDescription: '',
      canRemotely: false);

  JobAdModel get getCurrentJob => _currentJob;

  void setCurrentJob(JobAdModel newJobVals) {
    _currentJob = newJobVals;
  }
}
