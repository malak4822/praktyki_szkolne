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
                  child: IconButton(
                      alignment: Alignment.topLeft,
                      iconSize: 28,
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios_rounded,
                          color: Colors.white)),
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
                          maxLines: 1,
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
                                decoration: const BoxDecoration(
                                  boxShadow: myBoxShadow,
                                  gradient: LinearGradient(colors: gradient),
                                ),
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
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              contactBox(Icons.email_rounded, '', false, () {
                Provider.of<EditUser>(context, listen: false)
                    .toogleEditingPopUp(3);
              }),
              const SizedBox(width: 16),
              contactBox(Icons.phone, '', false, () {
                Provider.of<EditUser>(context, listen: false)
                    .toogleEditingPopUp(3);
              }),
            ],
          )
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
