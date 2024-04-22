import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prakty/constants.dart';
import 'package:prakty/models/advertisements_model.dart';
import 'package:prakty/models/user_model.dart';
import 'package:prakty/pages/jobs/jobadvertisement.dart';
import 'package:prakty/view/userpage.dart';

class NoticeCard extends StatelessWidget {
  const NoticeCard({super.key, required this.noticeType, required this.info});

  final dynamic info;
  final String noticeType;
  // String noticeType -> OPTIONS: 'userNotice', 'jobNotice', 'jobNotice', jobNoticeEditable

  @override
  Widget build(BuildContext context) {
    bool isUserNotice = false;

    MyUser? userNoticeInfo;
    JobAdModel? jobNoticeInfo;

    if (noticeType == 'userNotice') {
      userNoticeInfo = info;
      isUserNotice = true;
    } else {
      jobNoticeInfo = info;
    }

    return Container(
        height: 120,
        decoration: BoxDecoration(
            boxShadow: myBoxShadow,
            gradient: const LinearGradient(colors: gradient),
            borderRadius: BorderRadius.circular(12)),
        child: Material(
            color: Colors.transparent,
            child: InkWell(
                borderRadius: BorderRadius.circular(12),
                highlightColor: const Color.fromARGB(255, 28, 206, 222),
                splashColor: const Color.fromARGB(255, 34, 237, 255),
                splashFactory: InkRipple.splashFactory,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => isUserNotice
                            ? UserPage(
                                isOwnProfile: false, shownUser: userNoticeInfo!)
                            : JobAdvertisement(
                                jobInfo: jobNoticeInfo!,
                                isOfferEditable: noticeType == 'jobNoticeEditable'
                                    ? true
                                    : false),
                      ));
                },
                child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    child: Row(children: [
                      Expanded(
                          flex: 3,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  isUserNotice
                                      ? userNoticeInfo!.username
                                      : jobNoticeInfo!.jobName,
                                  style: fontSize20,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                                if (isUserNotice
                                    ? userNoticeInfo!.description != null
                                    : jobNoticeInfo!.jobDescription != '')
                                  Text(
                                      isUserNotice
                                          ? userNoticeInfo!.description!
                                          : jobNoticeInfo!.jobDescription,
                                      maxLines: 2,
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.overpass(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                                Row(
                                  children: [
                                    if (isUserNotice
                                        ? false
                                        : jobNoticeInfo!.canRemotely)
                                      Expanded(
                                          child: Row(
                                        children: [
                                          const Icon(Icons.done_outline_rounded,
                                              size: 18, color: Colors.white),
                                          Text(' Zdalne ',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.overpass(
                                                  fontSize: 12,
                                                  color: Colors.white)),
                                        ],
                                      )),
                                    if (isUserNotice
                                        ? userNoticeInfo!.location != null
                                        : true)
                                      Expanded(
                                          child: Row(children: [
                                        const Icon(Icons.location_city,
                                            size: 18, color: Colors.white),
                                        Expanded(
                                            child: Text(
                                                ' ${isUserNotice ? userNoticeInfo!.location : jobNoticeInfo!.jobLocation}',
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: GoogleFonts.overpass(
                                                    fontSize: 12,
                                                    color: Colors.white))),
                                      ])),
                                  ],
                                )
                              ])),
                      const SizedBox(width: 10),
                      CircleAvatar(
                        radius: 58,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 52,
                          backgroundColor:
                              const Color.fromARGB(255, 88, 231, 244),
                          child: ClipOval(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: FadeInImage.assetNetwork(
                                fit: BoxFit.cover,
                                height: 104,
                                width: 104,
                                filterQuality: FilterQuality.low,
                                placeholderFilterQuality: FilterQuality.low,
                                placeholder: isUserNotice
                                    ? 'images/photos/man_praktyki.png'
                                    : 'images/photos/company_icon.png',
                                image: isUserNotice
                                    ? info.profilePicture ??
                                        'https://firebasestorage.googleapis.com/v0/b/praktyki-szkolne.appspot.com/o/my_files%2Fman_praktyki.png?alt=media&token=dec782e2-1e50-4066-b0b6-0dc8019463d8'
                                    : info.jobImage ??
                                        'https://firebasestorage.googleapis.com/v0/b/praktyki-szkolne.appspot.com/o/my_files%2Fcompany_icon.png?alt=media&token=7c9796bf-2b8b-40d4-bc71-b85aeb82c269',
                                imageErrorBuilder:
                                    (context, error, stackTrace) => Image.asset(
                                          isUserNotice
                                              ? 'images/photos/man_praktyki.png'
                                              : 'images/photos/company_icon.png',
                                        )),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                    ])))));
  }
}
