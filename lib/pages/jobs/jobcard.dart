import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prakty/constants.dart';

class JobNotice extends StatelessWidget {
  const JobNotice({super.key, required this.jobData, required this.index});
  final int index;
  final List jobData;

  @override
  Widget build(BuildContext context) {
    final particularJob = jobData[index];
    return InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/advertisement',
              arguments: particularJob);
        },
        child: Container(
            decoration: BoxDecoration(
                boxShadow: myBoxShadow,
                gradient: const LinearGradient(colors: gradient),
                borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: SizedBox(
                height: 120,
                child: Row(children: [
                  Expanded(
                      flex: 3,
                      child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  particularJob['companyName'],
                                  style: fontSize20,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                                Text(particularJob['jobDescription'],
                                    maxLines: 3,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.overpass(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.location_city,
                                        size: 18, color: Colors.white),
                                    Expanded(
                                        child: Text(
                                            ' ${particularJob['jobLocation']}',
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: GoogleFonts.overpass(
                                                fontSize: 12,
                                                color: Colors.white))),
                                    const SizedBox(width: 10),
                                    if (particularJob['canRemotely'] == true)
                                      const Icon(Icons.done,
                                          size: 18, color: Colors.white),
                                    if (particularJob['canRemotely'] == true)
                                      Text(' Zdalne',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.overpass(
                                              fontSize: 12,
                                              color: Colors.white)),
                                  ],
                                )
                              ]))),
                  CircleAvatar(
                      radius: 52.5,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 50,
                        foregroundImage: NetworkImage(
                          particularJob['jobImage'] ??
                              'https://firebasestorage.googleapis.com/v0/b/praktyki-szkolne.appspot.com/o/my_files%2Fcompany_icon.png?alt=media&token=7c9796bf-2b8b-40d4-bc71-b85aeb82c269&_gl=1*1jkb7r2*_ga*MTA3NzgyMTMyOS4xNjg5OTUwMTkx*_ga_CW55HF8NVT*MTY5NzMyMjExOC45NC4xLjE2OTczMjIzNTEuNjAuMC4w',
                        ),
                      )),
                  const SizedBox(width: 10),
                ]))));
  }
}
