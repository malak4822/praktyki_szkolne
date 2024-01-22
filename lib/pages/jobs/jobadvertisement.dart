import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:prakty/constants.dart';
import 'package:prakty/models/advertisements_model.dart';
import 'package:prakty/models/user_model.dart';
import 'package:prakty/pages/jobs/addeditjob.dart';
import 'package:prakty/providers/editjobprov.dart';
import 'package:prakty/providers/googlesign.dart';
import 'package:prakty/services/database.dart';
import 'package:prakty/view/userpage.dart';
import 'package:prakty/widgets/topbuttons.dart';
import 'package:prakty/widgets/contactbox.dart';
import 'package:provider/provider.dart';

class JobAdvertisement extends StatefulWidget {
  const JobAdvertisement({super.key, required this.jobInfo});

  final JobAdModel jobInfo;
  @override
  State<JobAdvertisement> createState() => _JobAdvertisementState();
}

class _JobAdvertisementState extends State<JobAdvertisement> {
  Future<MyUser?>? ownerData;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    ownerData = MyDb().takeAdOwnersData(widget.jobInfo.belongsToUser);
    if (ownerData != null) {
      ownerData!.then((value) {
        if (Provider.of<GoogleSignInProvider>(context, listen: false)
                .getCurrentUser
                .userId ==
            value!.userId) {
          setState(() {
            isOwnNotice = true;
          });
        }
      });
    }
    super.initState();
  }

  bool isOwnNotice = false;
  void showSnackBar(BuildContext context, String text) {
    final snackBar = SnackBar(
      padding: const EdgeInsets.fromLTRB(46, 4, 0, 4),
      backgroundColor: gradient[1].withOpacity(0.86),
      showCloseIcon: true,
      content: Text(
        text,
        style: fontSize16,
        textAlign: TextAlign.center,
      ),
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    final JobAdModel jobInfo = widget.jobInfo;
    return
        // Consumer<EditJobProvider>(builder: (context, value, child) {
        // var curerntJob =
        //     Provider.of<EditJobProvider>(context, listen: false).getCurrentJob;
        // print(value.getCurrentJob.belongsToUser);

        // return
        Scaffold(
      body: SafeArea(
          child: Stack(children: [
        Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                boxShadow: myBoxShadow,
                gradient: const LinearGradient(colors: gradient),
                borderRadius: BorderRadius.circular(16)),
            child: ListView(children: [
              SizedBox(
                  height: jobInfo.jobImage == null ? 90 : 150,
                  child: Row(
                    children: [
                      if (jobInfo.jobImage != null)
                        Container(
                            margin: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                boxShadow: myOutlineBoxShadow,
                                borderRadius: BorderRadius.circular(16)),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.network(jobInfo.jobImage!,
                                    width: 150,
                                    height: 150,
                                    fit: BoxFit.cover))),
                      Expanded(
                          child: InkWell(
                              onTap: () =>
                                  showSnackBar(context, 'Nazwa Stanowiska'),
                              child: AnimatedContainer(
                                  height: double.maxFinite,
                                  margin: const EdgeInsets.all(8),
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      color: Colors.white12,
                                      boxShadow: myOutlineBoxShadow,
                                      borderRadius: BorderRadius.circular(16)),
                                  duration: const Duration(milliseconds: 300),
                                  child: Center(
                                      child: Text(
                                    jobInfo.jobName,
                                    style: fontSize20,
                                    textAlign: TextAlign.center,
                                    maxLines: jobInfo.jobImage == null ? 2 : 4,
                                    overflow: TextOverflow.ellipsis,
                                  )))))
                    ],
                  )),

              InkWell(
                  onTap: () => showSnackBar(context, 'Opis Stanowiska'),
                  child: Container(
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          color: Colors.white12,
                          boxShadow: myOutlineBoxShadow,
                          borderRadius: BorderRadius.circular(16)),
                      child: Text(jobInfo.jobDescription,
                          style: fontSize16, textAlign: TextAlign.center))),

              const SizedBox(height: 12),
              SizedBox(
                  height: 76,
                  child: Center(
                      child: ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: [
                      contactBox(Icons.email_outlined,
                          'mailto:${jobInfo.jobEmail}', true),
                      const SizedBox(width: 12),
                      contactBox(
                          Icons.phone, 'tel:+48${jobInfo.jobPhone}', true),
                      const SizedBox(width: 12),
                      contactBox(Icons.sms_outlined,
                          'sms:+48${jobInfo.jobPhone}', true),
                      const SizedBox(width: 12),
                      contactBox(
                          Icons.pin_drop_outlined,
                          "https://www.google.com/maps/search/?api=1&query=${jobInfo.jobLocation}",
                          true),
                    ],
                  ))),

              const SizedBox(height: 12),
              // COMPANY NAME
              InkWell(
                  onTap: () => showSnackBar(
                      context, 'Kwalifikacja, Informacje dodatkowe'),
                  child: Container(
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          color: Colors.white12,
                          boxShadow: myOutlineBoxShadow,
                          borderRadius: BorderRadius.circular(16)),
                      child: Column(children: [
                        if (jobInfo.jobQualification.isNotEmpty)
                          Text(jobInfo.jobQualification,
                              style: fontSize16, textAlign: TextAlign.center),
                        if (jobInfo.jobQualification.isNotEmpty)
                          const Divider(color: Colors.white, thickness: 2),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon((Icons.done_outline_rounded),
                                  size: 18, color: Colors.white),
                              Text(' Zdalne',
                                  style: fontSize16,
                                  textAlign: TextAlign.center)
                            ])
                      ]))),
              InkWell(
                  onTap: () =>
                      showSnackBar(context, 'Nazwa Firmy, Twórca Ogłoszenia'),
                  child: Container(
                      height: 180,
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          boxShadow: myOutlineBoxShadow,
                          color: Colors.white12,
                          borderRadius: BorderRadius.circular(16)),
                      child: Column(
                        children: [
                          Text(jobInfo.companyName,
                              style: fontSize20,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis),
                          const Divider(color: Colors.white, thickness: 2),
                          const SizedBox(height: 8),
                          FutureBuilder(
                              future: ownerData,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Expanded(
                                      child: Center(
                                          child: CircularProgressIndicator(
                                              backgroundColor: gradient[0],
                                              color: gradient[1],
                                              strokeWidth: 10)));
                                } else if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}',
                                        style: fontSize16);
                                  } else if (snapshot.data == null) {
                                    return Center(
                                        child: Text('Brak Informacji',
                                            style: fontSize16));
                                  } else {
                                    String employerName =
                                        snapshot.data!.username;
                                    String? employerImage =
                                        snapshot.data!.profilePicture;

                                    return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      UserPage(
                                                        isOwnProfile: false,
                                                        shownUser:
                                                            snapshot.data!,
                                                      )));
                                        },
                                        child: SizedBox(
                                            height: 90,
                                            child: Row(
                                              children: [
                                                Expanded(
                                                    child: Container(
                                                        decoration: BoxDecoration(
                                                            gradient:
                                                                const LinearGradient(
                                                                    colors:
                                                                        gradient),
                                                            border: Border.all(
                                                                width: 2,
                                                                color: Colors
                                                                    .white),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        16)),
                                                        child: Center(
                                                            child: Text(
                                                          'Dodane Przez \n $employerName',
                                                          style: fontSize16,
                                                          textAlign:
                                                              TextAlign.center,
                                                          overflow:
                                                              TextOverflow.clip,
                                                        )))),
                                                const SizedBox(width: 8),
                                                Container(
                                                    height: 90,
                                                    width: 90,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      border: Border.all(
                                                          color: Colors.white,
                                                          width: 2),
                                                    ),
                                                    child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(16),
                                                        child: Image.network(
                                                            employerImage ??
                                                                'https://firebasestorage.googleapis.com/v0/b/praktyki-szkolne.appspot.com/o/my_files%2Fman_praktyki.png?alt=media&token=dec782e2-1e50-4066-b0b6-0dc8019463d8&_gl=1*1dz5x65*_ga*MTA3NzgyMTMyOS4xNjg5OTUwMTkx*_ga_CW55HF8NVT*MTY5Njk2NTIzNy45MS4xLjE2OTY5NjUzOTkuNjAuMC4w',
                                                            fit:
                                                                BoxFit.cover))),
                                              ],
                                            )));
                                  }
                                } else {
                                  return const SizedBox();
                                }
                              }),
                        ],
                      ))),
            ])),
        backButton(context),
        if (isOwnNotice)
          Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                  onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddEditJob(
                                    initialEditingVal: jobInfo,
                                  ))).then((value) {
                        setState(() {});
                      }),
                  child: Container(
                      width: 62,
                      height: 62,
                      alignment: Alignment.topRight,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: gradient[1],
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(62))),
                      child: const FaIcon(Icons.edit_document,
                          color: Colors.white, size: 28)))),
        if (Provider.of<GoogleSignInProvider>(context, listen: false)
            .getCurrentUser
            .isAccountTypeUser)
          HeartButton(
            isOnUserPage: false,
            noticeId: jobInfo.jobId,
            userId: Provider.of<GoogleSignInProvider>(context, listen: false)
                .getCurrentUser
                .userId,
            initialValue:
                Provider.of<GoogleSignInProvider>(context, listen: false)
                        .getCurrentUser
                        .likedOffers
                        .contains(jobInfo.jobId)
                    ? 1
                    : 0,
          ),
      ])),
      // )
      // ;
      // }
    );
  }
}
