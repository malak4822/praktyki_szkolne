import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prakty/providers/edituser.dart';
import 'package:prakty/providers/googlesign.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../widgets/skillboxes.dart';

class UserPage extends StatelessWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var currentUser = Provider.of<GoogleSignInProvider>(context).getCurrentUser;
    var editUserFunction = Provider.of<EditUser>(context, listen: false);
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
            Align(
                alignment: const Alignment(0.9, -0.8),
                child: InkWell(
                    onTap: () {
                      editUserFunction.checkEmptiness(
                          currentUser.username,
                          currentUser.description,
                          currentUser.age,
                          currentUser.location);

                      Navigator.pushNamed(context, '/editUser');
                    },
                    child: const Image(
                        image: AssetImage('images/menuicon.png'), height: 30))),
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
                          image: currentUser.profilePicture.isNotEmpty
                              ? NetworkImage(currentUser.profilePicture)
                              : const AssetImage('images/man/man.png')
                                  as ImageProvider<Object>,
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
                Text(currentUser.username,
                    softWrap: true,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.overpass(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800)),
                Center(
                    child: Text(
                  textAlign: TextAlign.center,
                  '${currentUser.age == 0 ? '' : '${currentUser.age.toString()} lat,'}  ${currentUser.location}',
                  style:
                      GoogleFonts.overpass(color: Colors.white, fontSize: 16),
                )),
                const SizedBox(height: 5),
                Text(currentUser.description,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.overpass(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
              ]),
            )
          ])),
      Visibility(
          visible: currentUser.skillsSet.isNotEmpty,
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
                          itemCount: currentUser.skillsSet.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) => skillBox(
                              currentUser.skillsSet[index].keys.single,
                              currentUser.skillsSet[index].values.single,
                              context,
                              true)))))),
    ]));
  }
}
