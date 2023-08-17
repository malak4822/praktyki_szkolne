import 'package:flutter/material.dart';
import 'package:prakty/main.dart';
import 'package:prakty/providers/edituser.dart';
import 'package:prakty/providers/googlesign.dart';
import 'package:prakty/widgets/inputwindows.dart';
import 'package:prakty/widgets/skillboxes.dart';
import 'package:provider/provider.dart';
import '../services/database.dart';

class EditPopUpParent extends StatefulWidget {
  const EditPopUpParent({super.key});

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
      Expanded(child: GestureDetector(onTap: () {
        // if (Provider.of<EditUser>(context).tabToOpen == 2) {
        //   print("ZAMYKAM STREONE NR 3 :):):)");
        // }
        Provider.of<EditUser>(context, listen: false).toogleEditingPopUp(0);
      })),
      Expanded(
          flex: 3,
          child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: gradient),
                  borderRadius:
                      BorderRadius.vertical(top: Radius.elliptical(200, 40))),
              child:
                  editWidgetTypes[Provider.of<EditUser>(context).tabToOpen])),
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
    final TextEditingController descriptionCont =
        TextEditingController(text: user.description);
    var editUserFunction = Provider.of<EditUser>(context, listen: false);

    return Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            updateValues(nameCont, 'Imię I Nazwisko', 1, 24),
            const SizedBox(height: 6),
            Expanded(child: updateValues(descriptionCont, 'Opis', 14, 500)),
            IconButton(
                onPressed: () async {
                  await MyDb().updateNameAndDescription(user.userId,
                      nameCont.text, descriptionCont.text, context);
                  editUserFunction.toogleEditingPopUp(0);
                  editUserFunction.checkEmptiness(
                      descriptionCont.text.isEmpty, nameCont.text.isEmpty);
                },
                icon: const Icon(size: 38, Icons.done, color: Colors.white))
          ],
        ));
  }

  Widget editSkillSet(context) {
    var skillBoxes = Provider.of<EditUser>(context).skillBoxes;
    return Stack(children: [
      Column(
        children: [
          const Spacer(flex: 3),
          Expanded(
              flex: 5,
              child: Visibility(
                  visible: true,

                  /// dawhduwh ud
                  ///
                  child: Container(
                      width: MediaQuery.of(context).size.width * 2 / 5,
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
                            const Icon(Icons.star,
                                color: Colors.white, size: 58),
                            const SizedBox(height: 10),
                            Text(
                              skillBoxes.isNotEmpty
                                  ? skillBoxes[Provider.of<EditUser>(context)
                                          .currentChosenBox]
                                      .keys
                                      .single
                                  : '',
                              style: fontSize16,
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                    skillBoxes.isNotEmpty
                                        ? skillBoxes[
                                                Provider.of<EditUser>(context)
                                                    .currentChosenBox]
                                            .values
                                            .single
                                        : 0,
                                    (index) => const Padding(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 2),
                                        child: CircleAvatar(
                                          radius: 5,
                                          backgroundColor: Colors.white,
                                        ))))
                          ])))),
          const Spacer(flex: 3),
          Expanded(
              flex: 4,
              child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  addRepaintBoundaries: true,
                  itemCount: skillBoxes.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Row(
                      children: [
                        InkWell(
                            onTap: () =>
                                Provider.of<EditUser>(context, listen: false)
                                    .changeCurrentBox(index),
                            child: skillBox(
                                skillBoxes[index].keys.single,
                                skillBoxes[index].values.single,
                                context,
                                Provider.of<EditUser>(context)
                                            .currentChosenBox ==
                                        index
                                    ? false
                                    : true)),
                        if (skillBoxes.length - 1 == index)
                          Container(
                            margin: const EdgeInsets.only(left: 4),
                            height: 120,
                            width: 100,
                            decoration: BoxDecoration(
                                boxShadow: const [
                                  BoxShadow(
                                      color: Colors.black26,
                                      spreadRadius: 1,
                                      blurRadius: 2)
                                ],
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(8)),
                            child: IconButton(
                                iconSize: 38,
                                onPressed: () {
                                  Provider.of<EditUser>(context, listen: false)
                                      .addSkillBox();
                                },
                                icon:
                                    const Icon(Icons.add, color: Colors.white)),
                          ),
                      ],
                    );
                  })),
          const SizedBox(height: 20),
        ],
      ),
      Align(
          alignment: const Alignment(0, -0.3),
          child: Visibility(
              visible: false, child: changeCurrentBoxBackground(context))),
    ]);
  }

  Widget changeCurrentBoxBackground(context) {
    return Container(
        height: MediaQuery.of(context).size.height / 5,
        decoration: const BoxDecoration(
            color: Colors.white,
            border: Border.symmetric(
                horizontal: BorderSide(color: Colors.white, width: 2))));
  }
}
