import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prakty/constants.dart';
import 'package:prakty/models/user_model.dart';
import 'package:prakty/providers/edituser.dart';
import 'package:prakty/providers/googlesign.dart';
import 'package:prakty/widgets/contactbox.dart';
import 'package:provider/provider.dart';
import '../widgets/skillboxes.dart';

class UserPage extends StatelessWidget {
  UserPage({super.key, this.shownUser, required this.isOwnProfile});

  dynamic shownUser;
  bool isOwnProfile;

  @override
  Widget build(BuildContext context) {
    if (isOwnProfile) {
      MyUser myUser = Provider.of<GoogleSignInProvider>(context).getCurrentUser;
      shownUser = myUser.toMap();
    }
    String ageAndLocationString =
        '${shownUser['age'] == 0 ? '' : '${shownUser['age'].toString()} ${getAgeSuffix(shownUser['age'])}'}${shownUser['age'] != 0 || shownUser['location'] != '' ? ', ' : ''}${shownUser['location'] != '' ? '${shownUser['location']}' : ''}';

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
            if (isOwnProfile)
              Align(
                alignment: Alignment.topRight,
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Container(
                      width: 68,
                      height: 58,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(100)),
                          color: Colors.white),
                      padding: const EdgeInsets.all(14),
                    ),
                    IconButton(
                      iconSize: 22,
                      icon:
                          FaIcon(FontAwesomeIcons.userPen, color: gradient[1]),
                      onPressed: () {
                        Provider.of<EditUser>(context, listen: false)
                            .checkEmptiness(
                                shownUser['username'],
                                shownUser['description'],
                                shownUser['isAccountTypeUser']
                                    ? shownUser['age']
                                    : 1,
                                shownUser['isAccountTypeUser']
                                    ? shownUser['location']
                                    : 'a');

                        Navigator.pushNamed(context, '/editUser');
                      },
                    )
                  ],
                ),
              ),
            Center(
                child: CircleAvatar(
                    radius: 85,
                    backgroundColor: Colors.white,
                    child: Container(
                        height: 160,
                        width: 160,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(colors: gradient)),
                        child: ClipOval(
                            child: FadeInImage(
                          fit: BoxFit.cover,
                          fadeInDuration: const Duration(milliseconds: 500),
                          image: NetworkImage(shownUser['profilePicture'] != ''
                              ? shownUser['profilePicture']
                              : 'https://firebasestorage.googleapis.com/v0/b/praktyki-szkolne.appspot.com/o/my_files%2Fman_praktyki.png?alt=media&token=dec782e2-1e50-4066-b0b6-0dc8019463d8&_gl=1*5iyx8e*_ga*MTg3NTU1MzM0MC4xNjk4MzAyMTM5*_ga_CW55HF8NVT*MTY5OTI4NjY4OC42LjEuMTY5OTI4NjcwMS40Ny4wLjA.'),
                          placeholder: const NetworkImage(
                              'https://firebasestorage.googleapis.com/v0/b/praktyki-szkolne.appspot.com/o/my_files%2Fman_praktyki.png?alt=media&token=dec782e2-1e50-4066-b0b6-0dc8019463d8&_gl=1*5iyx8e*_ga*MTg3NTU1MzM0MC4xNjk4MzAyMTM5*_ga_CW55HF8NVT*MTY5OTI4NjY4OC42LjEuMTY5OTI4NjcwMS40Ny4wLjA.'),
                        ))))),
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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(children: [
                Center(
                    child: Text(shownUser['username'],
                        softWrap: true,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.overpass(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w800))),
                Visibility(
                    visible: shownUser['isAccountTypeUser'],
                    child: Center(
                        child: Text(
                      textAlign: TextAlign.center,
                      ageAndLocationString,
                      style: GoogleFonts.overpass(
                          color: Colors.white, fontSize: 16),
                    ))),
                const SizedBox(height: 5),
                if (shownUser['description'].isNotEmpty)
                  Text(shownUser['description'],
                      textAlign: TextAlign.center,
                      style: GoogleFonts.overpass(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
              ]),
            )
          ])),
      Visibility(
          visible: shownUser['skillsSet'].isNotEmpty,
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
                          itemCount: shownUser['skillsSet'].length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) => skillBox(
                              shownUser['skillsSet'][index].keys.single,
                              shownUser['skillsSet'][index].values.single,
                              context,
                              true)))))),
      const SizedBox(height: 8),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Visibility(
              visible: shownUser['email'].isNotEmpty,
              child: contactBox(
                  Icons.email_rounded, 'mailto:${shownUser['email']}', true)),
          const SizedBox(width: 10),
          Visibility(
              visible: shownUser['phoneNum'] != '',
              child: Row(
                children: [
                  contactBox(
                      Icons.phone, 'tel:+48${shownUser['phoneNum']}', true),
                  const SizedBox(width: 10),
                  contactBox(
                      Icons.sms, 'sms:+48${shownUser['phoneNum']}', true),
                ],
              )),
        ],
      ),
      const SizedBox(height: 16),
    ]));
  }
}
