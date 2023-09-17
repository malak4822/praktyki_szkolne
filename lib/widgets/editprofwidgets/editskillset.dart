import 'package:flutter/material.dart';
import 'package:prakty/main.dart';
import 'package:prakty/providers/edituser.dart';
import 'package:prakty/widgets/skillboxes.dart';
import 'package:provider/provider.dart';

class EditSkillSet extends StatefulWidget {
  const EditSkillSet({Key? key}) : super(key: key);

  @override
  State<EditSkillSet> createState() => _EditSkillSetState();
}

class _EditSkillSetState extends State<EditSkillSet> {
  @override
  Widget build(BuildContext context) {
    FocusNode myfocusNode = FocusNode();

    List<Map<String, int>> skillBoxes =
        Provider.of<EditUser>(context).skillBoxes;
    int chosenBox = Provider.of<EditUser>(context).currentChosenBox;

    int currentSkillLvl = 1; // Initialize with a default value
    TextEditingController skillCont = TextEditingController();

    if (skillBoxes.isNotEmpty) {
      if (chosenBox >= 0 && chosenBox < skillBoxes.length) {
        currentSkillLvl = skillBoxes[chosenBox].values.single;
        skillCont =
            TextEditingController(text: skillBoxes[chosenBox].keys.single);
      }
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.width * 2 / 9),
          Container(
            height: MediaQuery.of(context).size.width * 5 / 9,
            width: MediaQuery.of(context).size.width * 7 / 15,
            decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                  color: Colors.white,
                  spreadRadius: 0.3,
                  blurRadius: 5,
                ),
              ],
              gradient: const LinearGradient(colors: gradient),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.star, color: Colors.white, size: 48),
                const SizedBox(height: 10),
                TextField(
                  onSubmitted: (newTxt) {
                    newTxt = newTxt.replaceFirst(
                      newTxt[0],
                      newTxt[0].toUpperCase(),
                    );
                    Provider.of<EditUser>(context, listen: false)
                        .modifyMapElement(
                            skillBoxes[chosenBox], newTxt, currentSkillLvl);
                  },
                  textAlign: TextAlign.center,
                  controller: skillCont,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  maxLines: 1,
                  focusNode: myfocusNode,
                  style: fontSize20,
                  decoration: const InputDecoration.collapsed(
                    hintText: 'Skill',
                    hintStyle: TextStyle(color: Colors.white),
                  ),
                ),
                GestureDetector(
                  onTap: () => Provider.of<EditUser>(context, listen: false)
                      .addSkillLvl(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      skillBoxes.isNotEmpty ? currentSkillLvl : 1,
                      (index) => const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 2),
                        child: CircleAvatar(
                          radius: 5,
                          backgroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            iconSize: 38,
            onPressed: () =>
                Provider.of<EditUser>(context, listen: false).removeSkillBox(),
            icon: const Icon(Icons.delete, color: Colors.white),
          ),
          SizedBox(height: MediaQuery.of(context).size.width * 2 / 9),
          SizedBox(
            height: 120,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              addRepaintBoundaries: true,
              itemCount: skillBoxes.length + 1, // Add 1 for the "add" button
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                if (index == skillBoxes.length) {
                  // This is the "add" button
                  return Container(
                    margin: const EdgeInsets.only(left: 4),
                    height: 110,
                    width: 95,
                    decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          spreadRadius: 1,
                          blurRadius: 1.5,
                        ),
                      ],
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      iconSize: 38,
                      onPressed: () {
                        var prov = Provider.of<EditUser>(
                          context,
                          listen: false,
                        );
                        prov.addSkillBox();
                        prov.changeCurrentBox(skillBoxes.length);
                      },
                      icon: const Icon(Icons.add, color: Colors.white),
                    ),
                  );
                } else {
                  // This is a skill box
                  return InkWell(
                    onTap: () => Provider.of<EditUser>(context, listen: false)
                        .changeCurrentBox(index),
                    child: skillBox(
                      skillBoxes[index].keys.single,
                      skillBoxes[index].values.single,
                      context,
                      chosenBox == index ? false : true,
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}