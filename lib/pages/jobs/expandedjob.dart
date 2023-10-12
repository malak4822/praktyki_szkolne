import 'package:flutter/material.dart';
import 'package:prakty/main.dart';
import 'package:prakty/services/database.dart';
import 'package:url_launcher/url_launcher.dart';

class JobAdvertisement extends StatefulWidget {
  const JobAdvertisement({super.key});

  @override
  State<JobAdvertisement> createState() => _JobAdvertisementState();
}

class _JobAdvertisementState extends State<JobAdvertisement> {
  final List<BoxShadow> _myBoxShadow = const [
    BoxShadow(
        color: Colors.black54,
        spreadRadius: 0.3,
        blurRadius: 5,
        blurStyle: BlurStyle.outer)
  ];
  late Map arguments;
  List<String>? ownerData;

  @override
  void didChangeDependencies() async {
    arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    ownerData = await MyDb().takeAdOwnersData(arguments['belongsToUser']);
    setState(() {});
    super.didChangeDependencies();
  }

  Future<void> _launchUrl() async {
    if (!await launchUrl(Uri.parse('mailto:${arguments['jobEmail']}'))) {
      throw Exception('Could not launch url');
    }
  }

  Future<void> _launchSms() async {
    if (!await launchUrl(Uri.parse('sms:+48${arguments['jobPhone']}'))) {
      throw Exception('Could not launch url');
    }
  }

  Future<void> _launcdhUrl() async {
    if (!await launchUrl(Uri.parse('mailto:${arguments['jobEmail']}'))) {
      throw Exception('Could not launch url');
    }
  }

  Future<void> _phoneTo() async {
    if (!await launchUrl(Uri.parse('tel:+48${arguments['jobPhone']}'))) {
      throw Exception('Could not launch url');
    }
  }

  @override
  Widget build(BuildContext context) {
    var aBox = MediaQuery.sizeOf(context).width * 2 / 13;

    Widget interactionBox(icon, function) => Container(
          decoration: BoxDecoration(
              gradient: const LinearGradient(colors: gradient),
              borderRadius: BorderRadius.circular(16),
              boxShadow: myBoxShadow),
          child: ElevatedButton(
            onPressed: () => function(),
            style: ElevatedButton.styleFrom(
              fixedSize: Size(aBox, aBox),
              backgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
            ),
            child: Icon(icon, size: 32),
          ),
        );

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
              if (arguments['jobImage'] != null)
                Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      boxShadow: _myBoxShadow,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(arguments['jobImage'],
                            height: 220, fit: BoxFit.cover))),
              const SizedBox(height: 16),
              Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: Colors.white24,
                      boxShadow: _myBoxShadow,
                      borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    children: [
                      Text(arguments['jobName'],
                          style: fontSize20, textAlign: TextAlign.center),
                      const Divider(color: Colors.white, thickness: 2),
                      Text(arguments['jobDescription'],
                          style: fontSize16, textAlign: TextAlign.center),
                    ],
                  )),
              const SizedBox(height: 16),
              Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    interactionBox(Icons.email_rounded, () {
                      _launchUrl();
                    }),
                    interactionBox(Icons.phone, () {
                      _phoneTo();
                    }),
                    interactionBox(Icons.sms, () {
                      _launchSms();
                    }),
                    interactionBox(Icons.pin_drop_rounded, () {}),
                  ]),
              const SizedBox(height: 16),
              // COMPANY NAME
              Container(
                  height: 174,
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      boxShadow: _myBoxShadow,
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    children: [
                      Text(arguments['companyName'],
                          style: fontSize20,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis),
                      const Divider(color: Colors.white, thickness: 2),
                      const SizedBox(height: 8),
                      if (ownerData != null)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
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
                                      'Dodane Przez \n ${ownerData![1]}',
                                      style: fontSize16,
                                      textAlign: TextAlign.center,
                                    )))),
                            const SizedBox(width: 8),
                            Container(
                                width: 90,
                                height: 90,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  border:
                                      Border.all(color: Colors.white, width: 2),
                                ),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Image.network(
                                        ownerData![0] != ''
                                            ? ownerData![0]
                                            : 'https://firebasestorage.googleapis.com/v0/b/praktyki-szkolne.appspot.com/o/my_files%2Fman_praktyki.png?alt=media&token=dec782e2-1e50-4066-b0b6-0dc8019463d8&_gl=1*1dz5x65*_ga*MTA3NzgyMTMyOS4xNjg5OTUwMTkx*_ga_CW55HF8NVT*MTY5Njk2NTIzNy45MS4xLjE2OTY5NjUzOTkuNjAuMC4w',
                                        fit: BoxFit.cover))),
                          ],
                        )
                    ],
                  )),

              // ZAWÓD
              const SizedBox(height: 8),
              Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: Colors.white24,
                      boxShadow: _myBoxShadow,
                      borderRadius: BorderRadius.circular(16)),
                  child: Column(children: [
                    if (arguments['canRemotely'] == true)
                      Text(arguments['jobQualification'],
                          style: fontSize16, textAlign: TextAlign.center),
                    if (arguments['canRemotely'] == true)
                      const Divider(color: Colors.white, thickness: 2),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      const Icon((Icons.done_outline_rounded),
                          size: 18, color: Colors.white),
                      Text(' Zdalne',
                          style: fontSize16, textAlign: TextAlign.center)
                    ])
                  ]))
            ])),
        Container(
          width: 52,
          height: 52,
          decoration: const BoxDecoration(
              color: Color.fromARGB(255, 49, 182, 209),
              borderRadius:
                  BorderRadius.only(bottomRight: Radius.circular(50))),
          child: IconButton(
              alignment: Alignment.topLeft,
              iconSize: 28,
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios_rounded,
                  color: Colors.white)),
        ),
      ])),
    );
  }
}
