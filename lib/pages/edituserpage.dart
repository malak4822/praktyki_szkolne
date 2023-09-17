// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prakty/main.dart';
import 'package:prakty/providers/googlesign.dart';
import 'package:prakty/widgets/error.dart';
import 'package:provider/provider.dart';
import '../providers/edituser.dart';
import '../providers/loginconstrains.dart';
import '../services/database.dart';
import '../widgets/edituserpopup.dart';
import '../widgets/skillboxes.dart';

class EditUserPage extends StatelessWidget {
  const EditUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    var editUserProvider = Provider.of<EditUser>(context);
    var currentUser = Provider.of<GoogleSignInProvider>(context, listen: false)
        .getCurrentUser;
    int chosenBox = 0;

    return Scaffold(
        body: Stack(children: [
      ListView(children: [
        SizedBox(
            height: 200,
            child: Stack(children: [
              Container(
                height: 140,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: gradient),
                    borderRadius: BorderRadius.vertical(
                        bottom: Radius.elliptical(200, 30))),
              ),
              const Align(
                  alignment: Alignment(0.9, -0.8),
                  child: Image(
                      image: AssetImage('images/menuicon.png'), height: 30)),
              Center(
                  child: CircleAvatar(
                      radius: 85,
                      backgroundColor: Colors.white,
                      child: Container(
                          height: 160,
                          width: 160,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(colors: gradient),
                          ),
                          child: Stack(children: [
                            ClipOval(
                                child: FadeInImage(
                              fit: BoxFit.cover,
                              width: 160,
                              height: 160,
                              fadeInDuration: const Duration(milliseconds: 500),
                              image: currentUser.profilePicture.isNotEmpty
                                  ? NetworkImage(currentUser.profilePicture)
                                  : const AssetImage('images/man/man.png')
                                      as ImageProvider<Object>,
                              placeholder:
                                  const AssetImage('images/man/man.png'),
                            )),
                            ClipOval(child: blackBox(0, false, 0, context))
                          ]))))
            ])),
        SizedBox(
            height: 300,
            child: Column(children: [
              Expanded(
                  flex: 11,
                  child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 25),
                      decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: gradient),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black54,
                              spreadRadius: 0.3,
                              blurRadius: 5,
                            )
                          ]),
                      child: Stack(children: [
                        ListView(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            children: [
                              Text(
                                currentUser.username,
                                softWrap: true,
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.overpass(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w900),
                              ),
                              Text(currentUser.description,
                                  maxLines: 4,
                                  style: GoogleFonts.overpass(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                            ]),
                        blackBox(
                            1,
                            editUserProvider.isDescOrNameEmpty ? true : false,
                            0,
                            context)
                      ]))),
              Expanded(
                  flex: 9,
                  child: Padding(
                      padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width / 13,
                          right: MediaQuery.of(context).size.width / 13,
                          top: 6),
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: currentUser.skillsSet.isEmpty
                              ? 1
                              : currentUser.skillsSet.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            if (currentUser.skillsSet.isEmpty) {
                              return Container(
                                  height: 120,
                                  margin: const EdgeInsets.all(6),
                                  width: MediaQuery.of(context).size.width / 4,
                                  decoration: BoxDecoration(
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black54,
                                          spreadRadius: 0.3,
                                          blurRadius: 5,
                                        )
                                      ],
                                      gradient: const LinearGradient(colors: [
                                        Color.fromARGB(255, 1, 192, 209),
                                        Color.fromARGB(255, 0, 82, 156)
                                      ]),
                                      borderRadius: BorderRadius.circular(8)),
                                  child: blackBox(2, true, 0, context));
                              //
                            } else {
                              chosenBox = index;

                              return skillEditBox(
                                  currentUser.skillsSet[index].keys.single,
                                  currentUser.skillsSet[index].values.single,
                                  index,
                                  context);
                            }
                          }))),
            ])),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 0, 162, 226)),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Icon(Icons.home)),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 0, 162, 226)),
                onPressed: () {
                  Navigator.pop(context);
                  Provider.of<GoogleSignInProvider>(context, listen: false)
                      .logout();
                },
                child: const Icon(Icons.exit_to_app)),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 0, 162, 226)),
                onPressed: () async {
                  await MyDb().getUserInfo(context, currentUser.userId);
                  debugPrint(currentUser.username);
                  debugPrint(currentUser.description);

                  debugPrint(currentUser.email);
                  debugPrint(currentUser.skillsSet.toString());
                  debugPrint(currentUser.age.toString());
                  debugPrint(currentUser.isNormalUser.toString());
                  debugPrint(currentUser.profilePicture);
                  debugPrint(currentUser.userId);
                  debugPrint(currentUser.registeredViaGoogle.toString());
                  debugPrint(currentUser.accountCreated.toString());
                },
                child: const Icon(Icons.info))
          ],
        )
      ]),
      Visibility(
          visible: editUserProvider.isEditingSeen,
          child: const EditPopUpParent()),
      Visibility(
          visible: Provider.of<LoginConstrains>(context).showErrorMessage,
          child: const ErrorMessage()),
    ]));
  }
}

Widget blackBox(int index, bool isFirstTime, int boxChosen, context) {
  var editUserFunction = Provider.of<EditUser>(context, listen: false);
  return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8), color: Colors.black54),
      width: double.infinity,
      height: double.infinity,
      child: IconButton(
        iconSize: 34,
        onPressed: () async {
          if (isFirstTime) {
            try {
              editUserFunction.addSkillBox();
            } catch (e) {
              debugPrint(e.toString());
            }
          }
          Provider.of<EditUser>(context, listen: false).saveBackup();
          if (index == 2) {
            Provider.of<EditUser>(context, listen: false)
                .changeCurrentBox(boxChosen);
          }
          editUserFunction.toogleEditingPopUp(index);
        },
        icon: Icon(isFirstTime ? Icons.add : Icons.mode_edit_outlined),
        color: Colors.white,
      ));
}
