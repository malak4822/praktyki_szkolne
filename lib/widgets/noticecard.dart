import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prakty/constants.dart';
import 'package:prakty/models/advertisements_model.dart';
import 'package:prakty/models/user_model.dart';
import 'package:prakty/pages/jobs/jobadvertisement.dart';
import 'package:prakty/providers/googlesign.dart';
import 'package:prakty/view/userpage.dart';
import 'package:provider/provider.dart';

class NoticeCard extends StatelessWidget {
  const NoticeCard({super.key, required this.noticeType, required this.info});

  final dynamic info;
  final String noticeType;
  // String noticeType -> OPTIONS: 'userNotice', 'jobNotice', 'jobOwnNotice'

  NetworkImage showCorrectImage() {
    if (noticeType == 'userNotice') {
      return NetworkImage(info.profilePicture);
    } else {
      return NetworkImage(info.jobImage);
    }
  }

  @override
  Widget build(BuildContext context) {
    MyUser? userNoticeInfo;
    JobAdModel? jobNoticeInfo;

    if (noticeType == 'userNotice') {
      userNoticeInfo = info;
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
                highlightColor: Colors.blueAccent,
                splashColor: Colors.blue,
                splashFactory: InkRipple.splashFactory,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => noticeType == 'userNotice'
                            ? UserPage(
                                isOwnProfile: false, shownUser: userNoticeInfo!)
                            : JobAdvertisement(
                                jobInfo: jobNoticeInfo!,
                                areMyOffers: noticeType == 'jobOwnNotice'
                                    ? true
                                    : false),
                      )).then((value) {
                    Provider.of<GoogleSignInProvider>(context, listen: false)
                        .setState();
                  });
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
                                  noticeType == 'userNotice'
                                      ? userNoticeInfo!.username
                                      : jobNoticeInfo!.jobName,
                                  style: fontSize20,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                                if (noticeType == 'userNotice'
                                    ? userNoticeInfo!.description != null
                                    : jobNoticeInfo!.jobDescription != '')
                                  Text(
                                      noticeType == 'userNotice'
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
                                    if (noticeType == 'userNotice'
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
                                    if (noticeType == 'userNotice'
                                        ? userNoticeInfo!.location != null
                                        : true)
                                      Expanded(
                                          child: Row(children: [
                                        const Icon(Icons.location_city,
                                            size: 18, color: Colors.white),
                                        Expanded(
                                            child: Text(
                                                ' ${noticeType == 'userNotice' ? userNoticeInfo!.location : jobNoticeInfo!.jobLocation}',
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
                            backgroundColor: Colors.transparent,
                            child: ClipOval(
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              child: FadeInImage.assetNetwork(
                                  fit: BoxFit.cover,
                                  height: 104,
                                  width: 104,
                                  filterQuality: FilterQuality.low,
                                  placeholderFilterQuality: FilterQuality.low,
                                  placeholder: noticeType == 'userNotice'
                                      ? 'images/photos/man_praktyki.png'
                                      : 'images/photos/company_icon.png',
                                  image: noticeType == 'userNotice'
                                      ? info.profilePicture ??
                                          'images/photos/man_praktyki.png'
                                      : info.jobImage ??
                                          'images/photos/company_icon.png',
                                  imageErrorBuilder:
                                      (context, error, stackTrace) =>
                                          Image.asset(
                                            noticeType == 'userNotice'
                                                ? 'images/photos/man_praktyki.png'
                                                : 'images/photos/company_icon.png',
                                          )),
                            )),
                      ),
                      // CircleAvatar(
                      //     radius: 52,
                      //     backgroundColor: Colors.white,
                      // child: CircleAvatar(
                      //     radius: 48,
                      //     backgroundColor: Colors.white,
                      //     child: Container(
                      //         height: 96,
                      //         width: 96,
                      //         decoration: const BoxDecoration(
                      //             shape: BoxShape.circle,
                      //             color: Colors.transparent),
                      //         child: ClipOval(
                      //             child: FadeInImage(
                      //                 fit: BoxFit.cover,
                      //                 fadeInDuration:
                      //                     const Duration(milliseconds: 500),
                      //                 image: NetworkImage(
                      //                     noticeType == 'userNotice'
                      //                         ? info.profilePicture
                      //                         : info.jobImage),
                      //                 placeholder: AssetImage(noticeType ==
                      //                         'userNotice'
                      //                     ? 'images/photos/man_praktyki.png'
                      //                     : 'images/photos/company_icon.png'))))
                      // CircleAvatar(
                      //   radius: 50,
                      //   foregroundImage: NetworkImage(
                      //     showCorrectImage(),
                      //   ),
                      //   child: Container(
                      //     decoration: const BoxDecoration(
                      //         shape: BoxShape.circle,
                      //         gradient: LinearGradient(colors: gradient)),
                      //   ),
                      // )
                      // )),
                      const SizedBox(width: 10),
                    ])))));
  }
}
