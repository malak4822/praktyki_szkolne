import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prakty/constants.dart';
import 'package:prakty/providers/googlesign.dart';
import 'package:prakty/widgets/error.dart';
import 'package:provider/provider.dart';
import '../../providers/edituser.dart';
import '../../services/database.dart';
import '../../widgets/edituserpopup.dart';
import '../../widgets/skillboxes.dart';

class EditUserPage extends StatelessWidget {
  const EditUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    var editUserProvider = Provider.of<EditUser>(context);

    var currentUser = Provider.of<GoogleSignInProvider>(context, listen: false)
        .getCurrentUser;

    return Scaffold(
        body: Stack(children: [
      ListView(children: [
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
                        bottom: Radius.elliptical(200, 30))),
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
        Column(children: [
          Container(
              margin: const EdgeInsets.symmetric(horizontal: 25),
              decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: gradient),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: myBoxShadow),
              child: Stack(children: [
                Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Column(children: [
                      Text(currentUser.username,
                          style: GoogleFonts.overpass(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          )),
                      Center(
                          child: Text(
                        textAlign: TextAlign.center,
                        '${currentUser.age == 0 ? '' : '${currentUser.age.toString()} lat,'}  ${currentUser.location}',
                        style: GoogleFonts.overpass(
                            color: Colors.white, fontSize: 16),
                      )),
                      const SizedBox(height: 5),
                      Text(currentUser.description,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.overpass(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold))
                    ])),
                SizedBox(
                    height: 110,
                    child: blackBox(
                        1,
                        editUserProvider.areFieldsEmpty ? true : false,
                        0,
                        context))
              ])),
          SizedBox(
              height: 130,
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
                                  boxShadow: myBoxShadow,
                                  gradient:
                                      const LinearGradient(colors: gradient),
                                  borderRadius: BorderRadius.circular(8)),
                              child: blackBox(2, true, 0, context));
                        } else {
                          return skillEditBox(
                              currentUser.skillsSet[index].keys.single,
                              currentUser.skillsSet[index].values.single,
                              index,
                              context);
                        }
                      }))),
        ]),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 0, 162, 226)),
                onPressed: () => Navigator.pop(context),
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
                  debugPrint(currentUser.location);
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
          visible: editUserProvider.showErrorMessage,
          child: const ErrorMessage()),
    ]));
  }
}

Widget blackBox(int index, bool areFieldsEmpty, int boxChosen, context) {
  var editUserFunction = Provider.of<EditUser>(context, listen: false);
  return SizedBox.expand(
      child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8), color: Colors.black54),
          child: IconButton(
            iconSize: 34,
            onPressed: () async {
              if (index == 2) {
                editUserFunction.saveSkillBackup(
                    Provider.of<GoogleSignInProvider>(context, listen: false)
                        .getCurrentUser
                        .skillsSet);
                if (areFieldsEmpty) {
                  editUserFunction.addSkillBox();
                }
                editUserFunction.changeCurrentBox(boxChosen);
              }
              editUserFunction.toogleEditingPopUp(index);
            },
            icon: Icon(areFieldsEmpty ? Icons.add : Icons.mode_edit_outlined),
            color: Colors.white,
          )));
}
