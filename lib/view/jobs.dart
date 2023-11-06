import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prakty/constants.dart';
import 'package:prakty/services/database.dart';
import 'package:prakty/pages/jobs/jobcard.dart';

class JobNoticesPage extends StatelessWidget {
  JobNoticesPage({super.key, required this.isAccountTypeUser});

  bool isAccountTypeUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
        floatingActionButton: isAccountTypeUser == false
            ? FloatingActionButton(
                onPressed: () => Navigator.pushNamed(context, '/addJob'),
                child: const Icon(Icons.add))
            : null,
        body: SafeArea(
            child: FutureBuilder(
                future: MyDb().downloadJobAds(),
                builder: (context, AsyncSnapshot<List> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.location_searching_outlined,
                                    color: gradient[0], size: 52),
                                const SizedBox(height: 30),
                                Text(
                                    'Narazie Niestety Nie Ma Ogłoszeń W Twojej Okolicy',
                                    style: GoogleFonts.overpass(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w900,
                                        color: gradient[0]),
                                    textAlign: TextAlign.center)
                              ])),
                    );
                  } else {
                    final myJobList = snapshot.data;
                    return Container(
                        padding: const EdgeInsets.only(bottom: 10, top: 4),
                        child: ListView.builder(
                            clipBehavior: Clip.none,
                            itemCount: myJobList!.length,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              return JobNotice(
                                  jobData: myJobList, index: index);
                            }));
                  }
                })));
  }
}
