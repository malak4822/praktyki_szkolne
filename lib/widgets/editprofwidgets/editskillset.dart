import 'package:flutter/material.dart';
import 'package:prakty/main.dart';
import 'package:prakty/providers/edituser.dart';
import 'package:prakty/providers/googlesign.dart';
import 'package:prakty/services/database.dart';
import 'package:prakty/widgets/skillboxes.dart';
import 'package:provider/provider.dart';

class EditSkillSet extends StatefulWidget {
  const EditSkillSet({super.key});

  @override
  State<EditSkillSet> createState() => _EditSkillSetState();
}

FocusNode myfocusNode = FocusNode();

class _EditSkillSetState extends State<EditSkillSet> {
  @override
  Widget build(BuildContext context) {
    int boxIndex = Provider.of<EditUser>(context).currentChosenBox;
    List<Map<String, int>> skillBoxes =
        Provider.of<EditUser>(context).skillBoxes;
    int currentSkillLvl =
        skillBoxes[Provider.of<EditUser>(context).currentChosenBox]
            .values
            .single;

    final TextEditingController skillCont = TextEditingController(
        text: skillBoxes[Provider.of<EditUser>(context).currentChosenBox]
            .keys
            .single);
    return Column(
      children: [
        const Spacer(flex: 3),
        Container(
            height: MediaQuery.of(context).size.width * 5 / 9,
            width: MediaQuery.of(context).size.width * 7 / 15,
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
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Icon(Icons.star, color: Colors.white, size: 48),
              const SizedBox(height: 10),
              TextField(
                  onSubmitted: (a) => setState(() {}),
                  onTap: () => setState(() {}),
                  // onTapOutside: (event) => setState(() {}),
                  textAlign: TextAlign.center,
                  controller: skillCont,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  maxLines: 1,
                  focusNode: myfocusNode,
                  style: fontSize20,
                  decoration: const InputDecoration.collapsed(
                      hintText: 'Wpisz Umiejętność')),
              GestureDetector(
                  onTap: () => Provider.of<EditUser>(context, listen: false)
                      .addSkillLvl(),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                          skillBoxes.isNotEmpty ? currentSkillLvl : 0,
                          (index) => const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 2),
                              child: CircleAvatar(
                                radius: 5,
                                backgroundColor: Colors.white,
                              )))))
            ])),
        IconButton(
            iconSize: 32,
            onPressed: () {
              MyDb().updateSkillBoxes(
                  Provider.of<GoogleSignInProvider>(context, listen: false)
                      .getCurrentUser
                      .userId,
                  skillBoxes,
                  skillCont.text,
                  currentSkillLvl, // SKILL LVL
                  boxIndex, // BOX INDEX
                  context);
            },
            icon: const Icon(Icons.done, color: Colors.white)),
        Spacer(flex: !myfocusNode.hasFocus ? 2 : 1),
        AnimatedContainer(
            duration: const Duration(milliseconds: 600),
            height: !myfocusNode.hasFocus ? 120 : 0,
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
                              Provider.of<EditUser>(context).currentChosenBox ==
                                      index
                                  ? false
                                  : true)),
                      if (skillBoxes.length - 1 == index)
                        Container(
                          margin: const EdgeInsets.only(left: 4),
                          height: 110,
                          width: 95,
                          decoration: BoxDecoration(
                              boxShadow: const [
                                BoxShadow(
                                    color: Colors.black26,
                                    spreadRadius: 1,
                                    blurRadius: 1.5)
                              ],
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(8)),
                          child: IconButton(
                              iconSize: 38,
                              onPressed: () {
                                MyDb().updateSkillBoxes(
                                    Provider.of<GoogleSignInProvider>(context,
                                            listen: false)
                                        .getCurrentUser
                                        .userId,
                                    skillBoxes,
                                    'initSkill',
                                    0, // SKILL LVL
                                    boxIndex + 1, // BOX INDEX
                                    context);
                                Provider.of<EditUser>(context, listen: false)
                                    .addSkillBox();
                              },
                              icon: const Icon(Icons.add, color: Colors.white)),
                        ),
                    ],
                  );
                }
                // )
                )),
        const SizedBox(height: 30),
      ],
    );
  }
}
