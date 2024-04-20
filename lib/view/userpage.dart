import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prakty/constants.dart';
import 'package:prakty/models/user_model.dart';
import 'package:prakty/pages/user/edituserpage.dart';
import 'package:prakty/providers/edituser.dart';
import 'package:prakty/providers/googlesign.dart';
import 'package:prakty/widgets/topbuttons.dart';
import 'package:prakty/widgets/contactbox.dart';
import 'package:provider/provider.dart';
import '../widgets/skillboxes.dart';

class UserPage extends StatelessWidget {
  const UserPage(
      {super.key, required this.shownUser, required this.isOwnProfile});

  final MyUser shownUser;
  final bool isOwnProfile;

  @override
  Widget build(BuildContext context) {
    return Consumer<GoogleSignInProvider>(builder: ((context, value, child) {
      var userData = isOwnProfile
          ? Provider.of<GoogleSignInProvider>(context, listen: false)
              .getCurrentUser
          : shownUser;

      String locAndAge =
          Provider.of<GoogleSignInProvider>(context, listen: false)
              .setAgeAndLocString(shownUser.age, shownUser.location);

      return Scaffold(
          body: ListView(children: [
        SizedBox(
            height: 200,
            child: Stack(children: [
              Container(
                  height: 140,
                  decoration: const BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black38,
                            spreadRadius: 0.1,
                            blurRadius: 12,
                            offset: Offset(0, 6))
                      ],
                      gradient: LinearGradient(colors: gradient),
                      borderRadius: BorderRadius.vertical(
                          bottom: Radius.elliptical(200, 30)))),
              if (isOwnProfile ||
                  Provider.of<GoogleSignInProvider>(context, listen: false)
                          .getCurrentUser
                          .userId !=
                      shownUser.userId)
                Align(
                  alignment: Alignment.topRight,
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      if (isOwnProfile)
                        GestureDetector(
                            onTap: () {
                              Provider.of<EditUser>(context, listen: false)
                                  .checkEmptiness(
                                      userData.username,
                                      userData.description ?? '',
                                      userData.age,
                                      userData.location);

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const EditUserPage()));
                            },
                            child: Container(
                              width: 64,
                              height: 54,
                              padding: const EdgeInsets.all(10),
                              alignment: Alignment.topRight,
                              decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(56)),
                                  color: Colors.white),
                              child: FaIcon(
                                FontAwesomeIcons.userPen,
                                color: gradient[1],
                                size: isOwnProfile ? 22 : 26,
                              ),
                            )),
                      if (!isOwnProfile &&
                          !Provider.of<GoogleSignInProvider>(context,
                                  listen: false)
                              .getCurrentUser
                              .isAccountTypeUser)
                        HeartButton(
                          isOnUserPage: true,
                          noticeId: shownUser.userId,
                          userId: Provider.of<GoogleSignInProvider>(context,
                                  listen: false)
                              .getCurrentUser
                              .userId,
                          initialValue: Provider.of<GoogleSignInProvider>(
                                      context,
                                      listen: false)
                                  .getCurrentUser
                                  .likedOffers
                                  .contains(shownUser.userId)
                              ? 1
                              : 0,
                        )
                    ],
                  ),
                ),
              Center(
                  child: CircleAvatar(
                      radius: 86,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        backgroundColor:
                            const Color.fromARGB(255, 88, 231, 244),
                        radius: 80,
                        child: ClipOval(
                            child: FadeInImage.assetNetwork(
                          fit: BoxFit.cover,
                          height: 160,
                          width: 160,
                          filterQuality: FilterQuality.low,
                          placeholderFilterQuality: FilterQuality.low,
                          fadeInDuration: const Duration(milliseconds: 500),
                          image: userData.profilePicture ??
                              'https://firebasestorage.googleapis.com/v0/b/praktyki-szkolne.appspot.com/o/my_files%2Fman_praktyki.png?alt=media&token=dec782e2-1e50-4066-b0b6-0dc8019463d8&_gl=1*5iyx8e*_ga*MTg3NTU1MzM0MC4xNjk4MzAyMTM5*_ga_CW55HF8NVT*MTY5OTI4NjY4OC42LjEuMTY5OTI4NjcwMS40Ny4wLjA.',
                          imageErrorBuilder: (context, error, stackTrace) =>
                              Image.asset('images/photos/man_praktyki.png'),
                          placeholder: 'images/photos/man_praktyki.png',
                        )),
                      ))),
              if (!isOwnProfile)
                IconButton(
                    alignment: Alignment.topLeft,
                    iconSize: 28,
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios_rounded,
                        color: Colors.white)),
            ])),
        Container(
            margin: const EdgeInsets.symmetric(horizontal: 25),
            decoration: BoxDecoration(
                gradient: const LinearGradient(colors: gradient),
                borderRadius: BorderRadius.circular(8),
                boxShadow: myBoxShadow),
            child: Stack(children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(children: [
                  Center(
                      child: Text(userData.username,
                          softWrap: true,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.overpass(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w800))),
                  if (locAndAge.isNotEmpty)
                    Center(
                        child: Text(
                      textAlign: TextAlign.center,
                      locAndAge,
                      style: GoogleFonts.overpass(
                          color: Colors.white, fontSize: 16),
                    )),
                  const SizedBox(height: 5),
                  if (userData.description != null)
                    Text(userData.description!,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.overpass(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                ]),
              )
            ])),
        Visibility(
            visible: userData.skillsSet.isNotEmpty,
            child: SizedBox(
                height: 136,
                child: Padding(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width / 13,
                        right: MediaQuery.of(context).size.width / 13,
                        top: 6),
                    child: Center(
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: userData.skillsSet.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) => skillBox(
                                userData.skillsSet[index].keys.single,
                                userData.skillsSet[index].values.single,
                                context,
                                true)))))),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Visibility(
                visible: userData.email.isNotEmpty,
                child: contactBox(
                    Icons.email_rounded, 'mailto:${userData.email}', true)),
            const SizedBox(width: 10),
            Visibility(
                visible: userData.phoneNum != null
                    ? userData.phoneNum!.isNotEmpty
                    : false,
                child: Row(
                  children: [
                    contactBox(
                        Icons.phone, 'tel:+48${userData.phoneNum}', true),
                    const SizedBox(width: 10),
                    contactBox(Icons.sms, 'sms:+48${userData.phoneNum}', true),
                  ],
                )),
          ],
        ),
        const SizedBox(height: 16),
      ]));
    }));
  }
}
