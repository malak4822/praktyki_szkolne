import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prakty/constants.dart';
import 'package:prakty/pages/jobs/expandedjob.dart';
import 'package:prakty/view/userpage.dart';

class NoticeCard extends StatelessWidget {
  const NoticeCard(
      {super.key, required this.noticeCardName, required this.info});

  final Map info;
  final String noticeCardName;
  String showCorrectImage() {
    if (noticeCardName == 'UserCard') {
      if (info['profilePicture'] == null || info['profilePicture'] == '') {
        return 'https://firebasestorage.googleapis.com/v0/b/praktyki-szkolne.appspot.com/o/my_files%2Fman_praktyki.png?alt=media&token=dec782e2-1e50-4066-b0b6-0dc8019463d8&_gl=1*4wskaw*_ga*MTg3NTU1MzM0MC4xNjk4MzAyMTM5*_ga_CW55HF8NVT*MTY5OTI4NjY4OC42LjEuMTY5OTI4NjcwMS40Ny4wLjA';
      } else {
        return info['profilePicture'];
      }
    } else {
      if (info['jobImage'] == null || info['jobImage'] == '') {
        return 'https://firebasestorage.googleapis.com/v0/b/praktyki-szkolne.appspot.com/o/my_files%2Fcompany_icon.png?alt=media&token=7c9796bf-2b8b-40d4-bc71-b85aeb82c269';
      } else {
        return info['jobImage'];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => noticeCardName == 'UserCard'
                    ? UserPage(isOwnProfile: false, shownUser: info)
                    : JobAdvertisement(jobInfo: info),
              ));
        },
        child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
                boxShadow: myBoxShadow,
                gradient: const LinearGradient(colors: gradient),
                borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: SizedBox(
                height: 120,
                child: Row(children: [
                  Expanded(
                      flex: 3,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              info[noticeCardName == 'UserCard'
                                  ? 'username'
                                  : 'companyName'],
                              style: fontSize20,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                            if (info[noticeCardName == 'UserCard'
                                    ? 'description'
                                    : 'jobDescription']
                                .isNotEmpty)
                              Text(
                                  info[noticeCardName == 'UserCard'
                                      ? 'description'
                                      : 'jobDescription'],
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.overpass(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (info[noticeCardName == 'UserCard'
                                        ? 'location'
                                        : 'jobLocation']
                                    .isNotEmpty)
                                  const Icon(Icons.location_city,
                                      size: 18, color: Colors.white),
                                Expanded(
                                    child: Text(
                                        ' ${info[noticeCardName == 'UserCard' ? 'location' : 'jobLocation']}',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: GoogleFonts.overpass(
                                            fontSize: 12,
                                            color: Colors.white))),
                                const SizedBox(width: 10),
                                if (info['canRemotely'] == true)
                                  const Icon(Icons.done_outline_rounded,
                                      size: 18, color: Colors.white),
                                if (info['canRemotely'] == true)
                                  Text(' Zdalne',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.overpass(
                                          fontSize: 12, color: Colors.white)),
                              ],
                            )
                          ])),
                  const SizedBox(width: 10),
                  CircleAvatar(
                      radius: 53,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 50,
                        foregroundImage: NetworkImage(
                          showCorrectImage(),
                        ),
                        child: Container(
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(colors: gradient)),
                        ),
                      )),
                  const SizedBox(width: 10),
                ]))));
  }
}
