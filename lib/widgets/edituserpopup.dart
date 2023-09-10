import 'package:flutter/material.dart';
import 'package:prakty/main.dart';
import 'package:prakty/providers/edituser.dart';
import 'package:prakty/widgets/editprofwidgets/editskillset.dart';
import 'package:provider/provider.dart';
import '../providers/googlesign.dart';
import '../services/database.dart';
import 'editprofwidgets/editnamedesc.dart';
import 'editprofwidgets/editphotowidget.dart';

class EditPopUpParent extends StatefulWidget {
  const EditPopUpParent({super.key});

  @override
  State<EditPopUpParent> createState() => _EditPopUpParentState();
}

class _EditPopUpParentState extends State<EditPopUpParent> {
  @override
  Widget build(BuildContext context) {
    int tabToOpen = Provider.of<EditUser>(context).tabToOpen;
    var editUserFunction = Provider.of<EditUser>(context, listen: false);
    List<Widget> editWidgetTypes = [
      const EditPhoto(),
      const EditNameAndDesc(),
      const EditSkillSet(),
    ];

    return Column(children: [
      Expanded(child: GestureDetector(onTap: () async {
        if (tabToOpen == 2) {
          try {
            await MyDb().updateSkillBoxes(
                Provider.of<GoogleSignInProvider>(context, listen: false)
                    .getCurrentUser
                    .userId,
                editUserFunction.skillBoxes,
                context);
          } catch (e) {
            debugPrint(e.toString());
          }
        }
        editUserFunction.toogleEditingPopUp(0);
      })),
      Expanded(
          flex: 3,
          child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: gradient),
                  borderRadius:
                      BorderRadius.vertical(top: Radius.elliptical(200, 40))),
              child: editWidgetTypes[tabToOpen])),
    ]);
  }
}
