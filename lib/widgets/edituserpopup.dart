import 'package:flutter/material.dart';
import 'package:prakty/main.dart';
import 'package:prakty/providers/edituser.dart';
import 'package:prakty/providers/googlesign.dart';
import 'package:prakty/widgets/inputwindows.dart';
import 'package:provider/provider.dart';

import '../pages/userpage.dart';
import '../services/database.dart';

class EditPopUpParent extends StatefulWidget {
  const EditPopUpParent({super.key, required this.openWidgetIndex});

  final int openWidgetIndex;

  @override
  State<EditPopUpParent> createState() => _EditPopUpParentState();
}

class _EditPopUpParentState extends State<EditPopUpParent> {
  @override
  Widget build(BuildContext context) {
    // var listenEditUser = Provider.of<EditUser>(context).skillBoxAdeed;

    List<Widget> editWidgetTypes = [
      editPhoto(),
      editUserNameDescriptionPassword(context),
      editSkillSet(context),
    ];

    return Column(children: [
      Expanded(
          child: GestureDetector(
              onTap: () => Provider.of<EditUser>(context, listen: false)
                  .toogleEditingPopUp())),
      Expanded(
          flex: 3,
          child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: gradient),
                  borderRadius:
                      BorderRadius.vertical(top: Radius.elliptical(200, 40))),
              child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: editWidgetTypes[widget.openWidgetIndex]))),
    ]);
  }

  Widget editPhoto() {
    return const Column(
      children: [Text('SOME PHOTO HERE')],
    );
  }

  Widget editUserNameDescriptionPassword(context) {
    var user = Provider.of<GoogleSignInProvider>(context).getCurrentUser;
    final TextEditingController nameCont =
        TextEditingController(text: user.username);
    final TextEditingController description =
        TextEditingController(text: user.description);

    return Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            updateValues(nameCont, 'Imię I Nazwisko', 1, 24),
            //
            const SizedBox(height: 6),
            //
            Expanded(child: updateValues(description, 'Opis', 14, 500)),
            IconButton(
                onPressed: () async {
                  await MyDb().updateNameAndDescription(
                      user.userId, nameCont.text, description.text, context);
                  Provider.of<EditUser>(context, listen: false)
                      .toogleEditingPopUp();
                },
                icon: const Icon(size: 38, Icons.done, color: Colors.white))
          ],
        ));
  }

  Widget editSkillSet(context) {
    var skillBoxAdded = Provider.of<EditUser>(context).skillBoxAdeed;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(flex: 3),
        Expanded(
            flex: 5,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 100),
              decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black54,
                      spreadRadius: 0.3,
                      blurRadius: 5,
                    ),
                  ],
                  gradient: const LinearGradient(colors: gradient),
                  borderRadius: BorderRadius.circular(8)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.star, color: Colors.white, size: 58),
                  const SizedBox(height: 10),
                  Text('mainTile', style: fontSize16),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                          3,
                          (index) => const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 2),
                              child: CircleAvatar(
                                radius: 5,
                                backgroundColor: Colors.white,
                              ))))
                ],
              ),
            )),
        const Spacer(flex: 3),
        Expanded(
            flex: 4,
            child: SizedBox(
                child: ListView.builder(
                    shrinkWrap: true,
                    addRepaintBoundaries: true,
                    itemCount: skillBoxAdded,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Row(
                        children: [
                          skillBox('Text', 3, context),
                          if (skillBoxAdded - 1 == index)
                            InkWell(
                                onTap: () {
                                  Provider.of<EditUser>(context, listen: false)
                                      .addSkillBox();
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(left: 4),
                                  height: 120,
                                  width: 100,
                                  decoration: BoxDecoration(
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black26,
                                          spreadRadius: 1,
                                          blurRadius: 2,
                                        ),
                                      ],
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(8)),
                                  child: IconButton(
                                      iconSize: 38,
                                      onPressed: () {
                                        Provider.of<EditUser>(context,
                                                listen: false)
                                            .addSkillBox();
                                      },
                                      icon: const Icon(Icons.add,
                                          color: Colors.white)),
                                )),
                        ],
                      );
                    }))),
        const SizedBox(height: 20),
      ],
    );
  }
}
