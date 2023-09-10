import 'package:flutter/material.dart';
import 'package:prakty/main.dart';
import 'package:prakty/providers/edituser.dart';
import 'package:prakty/widgets/skillboxes.dart';
import 'package:provider/provider.dart';

class EditSkillSet extends StatefulWidget {
  const EditSkillSet({super.key});

  @override
  State<EditSkillSet> createState() => _EditSkillSetState();
}

class _EditSkillSetState extends State<EditSkillSet> {
  // @override
  // void didChangeDependencies() {
  //   skillCont = TextEditingController(
  //       text: Provider.of<EditUser>(context)
  //           .skillBoxes[
  //               Provider.of<EditUser>(context, listen: false).currentChosenBox]
  //           .keys
  //           .single);
  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    TextEditingController skillCont = Provider.of<EditUser>(context).skillCont;

    FocusNode myfocusNode = FocusNode();

    List<Map<String, int>> skillBoxes =
        Provider.of<EditUser>(context, listen: false).skillBoxes;

    int currentSkillLvl =
        skillBoxes[Provider.of<EditUser>(context).currentChosenBox]
            .values
            .single;

    int chosenBox = Provider.of<EditUser>(context).currentChosenBox;

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
                      color: Colors.black54, spreadRadius: 0.3, blurRadius: 5),
                ],
                gradient: const LinearGradient(colors: gradient),
                borderRadius: BorderRadius.circular(8)),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Icon(Icons.star, color: Colors.white, size: 48),
              const SizedBox(height: 10),
              TextField(
                  onSubmitted: (newTxt) => setState(() {
                        skillCont.text = newTxt;
                      }),
                  // onTap: () => setState(() {}),
                  // onTapOutside: (event) => setState(() {}),
                  textAlign: TextAlign.center,
                  controller: skillCont,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  maxLines: 1,
                  focusNode: myfocusNode,
                  style: fontSize20,
                  decoration:
                      const InputDecoration.collapsed(hintText: 'Umiejętność')),
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
        // IconButton(
        //     iconSize: 32,
        //     onPressed: () {
        //       try {
        //         MyDb().updateSkillBoxes(
        //             Provider.of<GoogleSignInProvider>(context, listen: false)
        //                 .getCurrentUser
        //                 .userId,
        //             skillBoxes,
        //             skillCont.text,
        //             currentSkillLvl);
        //       } catch (e) {
        //         debugPrint(e.toString());
        //       }
        //     },
        //     icon: const Icon(Icons.done, color: Colors.white)),
        SizedBox(height: MediaQuery.of(context).size.width * 2 / 9),
        ElevatedButton(
            onPressed: () {
              print("BACKUP :");
              print(Provider.of<EditUser>(context, listen: false)
                  .skillBoxesBackup);
              print("AKTUALNE :");
              print(Provider.of<EditUser>(context, listen: false).skillBoxes);
            },
            child: Text('CHECK IT')),
        Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
                height: 120,
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
                                  chosenBox == index ? false : true)),
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
                                    var prov = Provider.of<EditUser>(context,
                                        listen: false);
                                    prov.addSkillBox();
                                    prov.changeCurrentBox(
                                        skillBoxes.length - 1);
                                  },
                                  icon: const Icon(Icons.add,
                                      color: Colors.white)),
                            ),
                        ],
                      );
                    }))),
        const SizedBox(height: 30),
      ],
    ));
  }
}
