// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:prakty/main.dart';
import 'package:prakty/providers/edituser.dart';
import 'package:prakty/pages/editprofwidgets/editskillset.dart';
import 'package:provider/provider.dart';
import '../providers/googlesign.dart';
import '../providers/loginconstrains.dart';
import '../services/database.dart';
import '../pages/editprofwidgets/editnamedesc.dart';
import '../pages/editprofwidgets/editphotowidget.dart';

class EditPopUpParent extends StatefulWidget {
  const EditPopUpParent({super.key});

  @override
  State<EditPopUpParent> createState() => _EditPopUpParentState();
}

class _EditPopUpParentState extends State<EditPopUpParent> {
  var ageCont = 0;
  @override
  Widget build(BuildContext context) {
    int tabToOpen = Provider.of<EditUser>(context).tabToOpen;

    var editUserFunction = Provider.of<EditUser>(context, listen: false);

    var googleSignFunction =
        Provider.of<GoogleSignInProvider>(context, listen: false);

    Future<bool> internetCheck =
        Provider.of<LoginConstrains>(context, listen: false)
            .checkInternetConnectivity();
    var user = Provider.of<GoogleSignInProvider>(context).getCurrentUser;

    int ageCont = user.age;

    final TextEditingController nameCont =
        TextEditingController(text: user.username);

    final TextEditingController descriptionCont =
        TextEditingController(text: user.description);

    final TextEditingController locationCont =
        TextEditingController(text: user.location);

    List<Widget> editWidgetTypes = [
      const EditPhoto(),
      EditNameAndDesc(nameCont, descriptionCont, locationCont, ageCont,
          (newVal) => ageCont = newVal),
      const EditSkillSet(),
    ];

    return Column(children: [
      Expanded(child: GestureDetector(onTap: () async {
        editUserFunction.changeLoading();
        // Closing Photo Widget
        if (tabToOpen == 0) {
          if (await internetCheck) {
            try {
              var newUrlString = await MyDb()
                  .uploadImageToStorage(user.userId, editUserFunction.imgFile);
              if (newUrlString != null) {
                googleSignFunction.refreshProfilePicture(newUrlString);
              }
            } catch (e) {
              debugPrint(e.toString());
            }
          }
          editUserFunction.deleteSelectedImage();
        }
        // Closing Info Widget
        if (tabToOpen == 1) {
          if (await internetCheck) {
            try {
              await MyDb().updateInfoFields(user.userId, nameCont.text,
                  descriptionCont.text, locationCont.text, ageCont, context);
              editUserFunction.checkEmptiness(descriptionCont.text,
                  nameCont.text, ageCont, locationCont.text);
            } catch (e) {
              debugPrint(e.toString());
            }
          }
        }
        // Closing Skillset Widget
        if (tabToOpen == 2) {
          if (await internetCheck) {
            try {
              await MyDb().updateSkillBoxes(
                  user.userId, editUserFunction.skillBoxes, context);
            } catch (e) {
              debugPrint(e.toString());
            }
          } else {
            editUserFunction.restoreSkillBoxData();
            googleSignFunction.refreshSkillSet(editUserFunction.skillBoxes);
          }
        }
        editUserFunction.changeLoading();
        editUserFunction.toogleEditingPopUp(0);
      })),
      Expanded(
          flex: 4,
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
