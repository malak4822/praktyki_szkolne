import 'package:flutter/material.dart';
import 'package:prakty/constants.dart';
import 'package:prakty/services/database.dart';
import 'package:prakty/widgets/backbutton.dart';
import 'package:prakty/widgets/contactbox.dart';
import 'package:url_launcher/url_launcher.dart';

class JobAdvertisement extends StatefulWidget {
  const JobAdvertisement({super.key, required this.userInfo});

  final Map userInfo;
  @override
  State<JobAdvertisement> createState() => _JobAdvertisementState();
}

class _JobAdvertisementState extends State<JobAdvertisement> {
  Map? ownerData;

  @override
  Widget build(BuildContext context) {
    final userInfo = widget.userInfo;
    print(userInfo);

    return Scaffold(
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
              if (userInfo['jobImage'] != null)
                Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      boxShadow: myOutlineBoxShadow,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(userInfo['jobImage'],
                            height: 220, fit: BoxFit.cover))),
              const SizedBox(height: 16),
              Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: Colors.white24,
                      boxShadow: myOutlineBoxShadow,
                      borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    children: [
                      Text("Nazwa Stanowiska :",
                          style: fontSize16, textAlign: TextAlign.center),
                      const Divider(color: Colors.white, thickness: 2),
                      Text(userInfo['jobName'],
                          style: fontSize20, textAlign: TextAlign.center),
                      Text(userInfo['jobDescription'],
                          style: fontSize16, textAlign: TextAlign.center),
                    ],
                  )),
              const SizedBox(height: 16),
              Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    contactBox(Icons.email_rounded,
                        'mailto:${userInfo['jobEmail']}', true, null),
                    contactBox(Icons.phone,
                        'tel:+48${userInfo['jobPhone']}', true, null),
                    contactBox(Icons.sms, 'sms:+48${userInfo['jobPhone']}',
                        true, null),
                    contactBox(
                        Icons.pin_drop_rounded,
                        "https://www.google.com/maps/search/?api=1&query=${userInfo['jobLocation']}",
                        true,
                        null),
                  ]),
              const SizedBox(height: 16),
              // COMPANY NAME
              Container(
                  height: 180,
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      boxShadow: myOutlineBoxShadow,
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    children: [
                      Text(userInfo['companyName'],
                          style: fontSize20,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis),
                      const Divider(color: Colors.white, thickness: 2),
                      const SizedBox(height: 8),
                      FutureBuilder(
                        future:
                            MyDb().takeAdOwnersData(userInfo['belongsToUser']),
                        builder: (BuildContext context,
                            AsyncSnapshot<Map<dynamic, dynamic>?> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator(
                                backgroundColor: gradient[0],
                                color: gradient[1],
                                strokeWidth: 10);
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return Text('Brak Informacji', style: fontSize16);
                          } else {
                            String employerName = snapshot.data!['username'];
                            String employerImage =
                                snapshot.data!['profilePicture'];
                            return Row(
                              children: [
                                Expanded(
                                    child: Container(
                                        height: 90,
                                        decoration: BoxDecoration(
                                            gradient: const LinearGradient(
                                                colors: gradient),
                                            border: Border.all(
                                                width: 2, color: Colors.white),
                                            borderRadius:
                                                BorderRadius.circular(16)),
                                        child: Center(
                                            child: Text(
                                          'Dodane Przez \n $employerName',
                                          style: fontSize16,
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.clip,
                                        )))),
                                const SizedBox(width: 8),
                                Container(
                                    width: 90,
                                    height: 90,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                          color: Colors.white, width: 2),
                                    ),
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: Image.network(
                                            employerImage != ''
                                                ? employerImage
                                                : 'https://firebasestorage.googleapis.com/v0/b/praktyki-szkolne.appspot.com/o/my_files%2Fman_praktyki.png?alt=media&token=dec782e2-1e50-4066-b0b6-0dc8019463d8&_gl=1*1dz5x65*_ga*MTA3NzgyMTMyOS4xNjg5OTUwMTkx*_ga_CW55HF8NVT*MTY5Njk2NTIzNy45MS4xLjE2OTY5NjUzOTkuNjAuMC4w',
                                            fit: BoxFit.cover))),
                              ],
                            );
                          }
                        },
                      ),
                    ],
                  )),

              // ZAWÓD
              const SizedBox(height: 8),
              Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: Colors.white24,
                      boxShadow: myOutlineBoxShadow,
                      borderRadius: BorderRadius.circular(16)),
                  child: Column(children: [
                    if (userInfo['canRemotely'] == true)
                      Text(userInfo['jobQualification'],
                          style: fontSize16, textAlign: TextAlign.center),
                    if (userInfo['canRemotely'] == true)
                      const Divider(color: Colors.white, thickness: 2),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      const Icon((Icons.done_outline_rounded),
                          size: 18, color: Colors.white),
                      Text(' Zdalne',
                          style: fontSize16, textAlign: TextAlign.center)
                    ])
                  ]))
            ])),
        backButton(context),
      ])),
    );
  }
}
