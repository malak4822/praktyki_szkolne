import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prakty/constants.dart';
import 'package:prakty/providers/edituser.dart';
import 'package:prakty/providers/googlesign.dart';
import 'package:provider/provider.dart';
import '../widgets/skillboxes.dart';

class UserPage extends StatelessWidget {
  UserPage({Key? key, this.shownUser, required this.isOwnProfile})
      : super(key: key);
  dynamic shownUser;
  bool isOwnProfile;

  @override
  Widget build(BuildContext context) {
    if (isOwnProfile) {
      shownUser = Provider.of<GoogleSignInProvider>(context).getCurrentUser;
    }
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
                  alignment: const Alignment(0.9, -0.8),
                  child: InkWell(
                      onTap: () {
                        Provider.of<EditUser>(context, listen: false)
                            .checkEmptiness(
                                shownUser.username,
                                shownUser.description,
                                shownUser.age,
                                shownUser.location);

                        Navigator.pushNamed(context, '/editUser');
                      },
                      child: const Image(
                          image: AssetImage('images/menuicon.png'),
                          height: 30))),
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
                          image: isOwnProfile
                              ? shownUser.profilePicture.isNotEmpty
                                  ? NetworkImage(shownUser.profilePicture)
                                  : const AssetImage('images/man/man.png')
                                      as ImageProvider<Object>
                              : NetworkImage(shownUser[0]),
                          placeholder: const AssetImage('images/man/man.png'),
                        )))))
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
                    child: Text(
                        isOwnProfile ? shownUser.username : shownUser[1],
                        softWrap: true,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.overpass(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w800))),
                if (isOwnProfile)
                  Center(
                      child: Text(
                    textAlign: TextAlign.center,
                    '${shownUser.age == 0 ? '' : '${shownUser.age.toString()} lat,'}  ${shownUser.location}',
                    style:
                        GoogleFonts.overpass(color: Colors.white, fontSize: 16),
                  )),
                const SizedBox(height: 5),
                if (isOwnProfile)
                  Text(shownUser.description,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.overpass(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
              ]),
            )
          ])),
      if (isOwnProfile)
        Visibility(
            visible: shownUser.skillsSet.isNotEmpty,
            child: SizedBox(
                height: 130,
                child: Padding(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width / 13,
                        right: MediaQuery.of(context).size.width / 13,
                        top: 6),
                    child: Center(
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: shownUser.skillsSet.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) => skillBox(
                                shownUser.skillsSet[index].keys.single,
                                shownUser.skillsSet[index].values.single,
                                context,
                                true)))))),
    ]));
  }
}
