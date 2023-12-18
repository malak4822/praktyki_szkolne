import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prakty/constants.dart';
import 'package:prakty/pages/user/changeuserprivate.dart';
import 'package:prakty/providers/googlesign.dart';

import 'package:prakty/widgets/contactbox.dart';
import 'package:prakty/widgets/error.dart';
import 'package:provider/provider.dart';
import '../../providers/edituser.dart';
import '../../widgets/edituserpopup.dart';
import '../../widgets/skillboxes.dart';

class EditUserPage extends StatelessWidget {
  const EditUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    var editUserProvider = Provider.of<EditUser>(context);

    var currentUser = Provider.of<GoogleSignInProvider>(context, listen: false)
        .getCurrentUser;

    final pageCont = PageController(initialPage: 0);

    TextEditingController emailCont =
        TextEditingController(text: currentUser.email);

    return Scaffold(
        body: PageView(controller: pageCont, children: [
      Stack(children: [
        ListView(children: [
          SizedBox(
              height: 200,
              child: Stack(children: [
                Container(
                  width: MediaQuery.of(context).size.width,
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

                //BLAD, NIE PODKRESLA PRZY LOGOWANIU JAK EMAIL JEST ZLE SFORMATOWANY
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
                                fadeInDuration:
                                    const Duration(milliseconds: 500),
                                image: NetworkImage(currentUser
                                        .profilePicture.isNotEmpty
                                    ? currentUser.profilePicture
                                    : 'https://firebasestorage.googleapis.com/v0/b/praktyki-szkolne.appspot.com/o/my_files%2Fman_praktyki.png?alt=media&token=dec782e2-1e50-4066-b0b6-0dc8019463d8&_gl=1*5iyx8e*_ga*MTg3NTU1MzM0MC4xNjk4MzAyMTM5*_ga_CW55HF8NVT*MTY5OTI4NjY4OC42LjEuMTY5OTI4NjcwMS40Ny4wLjA.'),
                                placeholder: const NetworkImage(
                                    'https://firebasestorage.googleapis.com/v0/b/praktyki-szkolne.appspot.com/o/my_files%2Fman_praktyki.png?alt=media&token=dec782e2-1e50-4066-b0b6-0dc8019463d8&_gl=1*5iyx8e*_ga*MTg3NTU1MzM0MC4xNjk4MzAyMTM5*_ga_CW55HF8NVT*MTY5OTI4NjY4OC42LjEuMTY5OTI4NjcwMS40Ny4wLjA.'),
                              )),
                              ClipOval(child: blackBox(0, false, 0, context))
                            ])))),
                IconButton(
                    alignment: Alignment.topLeft,
                    iconSize: 28,
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios_rounded,
                        color: Colors.white)),
                Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                        iconSize: 32,
                        onPressed: () {
                          pageCont.animateToPage(
                            1,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        icon: const Icon(Icons.settings, color: Colors.white))),
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
                        Center(
                            child: Text(currentUser.username,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.overpass(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                ))),
                        Visibility(
                            visible: currentUser.isAccountTypeUser,
                            child: Center(
                                child: Text(
                              '${currentUser.age == 0 ? '' : '${currentUser.age.toString()} ${getAgeSuffix(currentUser.age)}'}${currentUser.location != '' ? ', ${currentUser.location}' : ''}',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.overpass(
                                  color: Colors.white, fontSize: 16),
                              maxLines: 1,
                            ))),
                        const SizedBox(height: 2),
                        Center(
                            child: Text(currentUser.description,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.overpass(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold)))
                      ])),
                  SizedBox(
                      height: currentUser.isAccountTypeUser ? 110 : 80,
                      child: blackBox(
                          1,
                          editUserProvider.areFieldsEmpty ? true : false,
                          0,
                          context))
                ])),
            Visibility(
                visible: currentUser.isAccountTypeUser,
                child: SizedBox(
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
                                    width:
                                        MediaQuery.of(context).size.width / 4,
                                    decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                      boxShadow: myBoxShadow,
                                      gradient:
                                          LinearGradient(colors: gradient),
                                    ),
                                    child: blackBox(2, true, 0, context));
                              } else {
                                return skillEditBox(
                                    currentUser.skillsSet[index].keys.single,
                                    currentUser.skillsSet[index].values.single,
                                    index,
                                    context);
                              }
                            })))),
          ]),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  contactBox(Icons.email_rounded, '', false),
                  IconButton(
                      onPressed: () {
                        Provider.of<EditUser>(context, listen: false)
                            .toogleEditingPopUp(3);
                      },
                      icon: const Icon(Icons.mode_edit_outlined),
                      color: Colors.white,
                      iconSize: 32),
                ],
              ),
              const SizedBox(width: 16),
              Stack(
                fit: StackFit.passthrough,
                alignment: Alignment.center,
                children: [
                  contactBox(Icons.phone, '', false),
                  IconButton(
                      onPressed: () {
                        Provider.of<EditUser>(context, listen: false)
                            .toogleEditingPopUp(3);
                      },
                      icon: const Icon(Icons.mode_edit_outlined),
                      color: Colors.white,
                      iconSize: 32),
                ],
              ),
            ],
          ),
        ]),
        Visibility(
            visible: editUserProvider.isEditingSeen,
            child: const EditPopUpParent()),
        Visibility(
            visible: editUserProvider.showErrorMessage,
            child: const ErrorMessage()),
      ]),
      EditPrivUserInfo(currentUser: currentUser, emailCont: emailCont)
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
