import 'package:flutter/material.dart';
import 'package:prakty/constants.dart';
import 'package:prakty/providers/edituser.dart';
import 'package:prakty/pages/user/editskillset.dart';
import 'package:provider/provider.dart';
import '../providers/googlesign.dart';
import '../services/database.dart';
import '../pages/user/editnamedesc.dart';
import '../pages/user/editphotowidget.dart';

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

    var user = Provider.of<GoogleSignInProvider>(context).getCurrentUser;

    int ageCont = user.age;

    final TextEditingController nameCont =
        TextEditingController(text: user.username);

    final TextEditingController descriptionCont =
        TextEditingController(text: user.description);

    final TextEditingController emailCont =
        TextEditingController(text: user.description);

    final TextEditingController locationCont =
        TextEditingController(text: user.location);

    List<Widget> editWidgetTypes = [
      const EditPhoto(),
      EditNameAndDesc(nameCont, descriptionCont, locationCont, ageCont,
          emailCont, (newVal) => ageCont = newVal),
      const EditSkillSet(),
    ];

    return Column(children: [
      Expanded(child: GestureDetector(onTap: () async {
        MyDb myDb = MyDb();
        editUserFunction.changeLoading();

        if (await editUserFunction.checkInternetConnectivity()) {
          // UPDATING PHOTO UPDATING PHOTO UPDATING PHOTO
          if (tabToOpen == 0) {
            var newUrlString = await myDb.uploadImageToStorage(
                user.userId, editUserFunction.imgFile);
            if (newUrlString != null) {
              googleSignFunction.refreshProfilePicture(newUrlString);
            }
            editUserFunction.deleteSelectedImage();
          }
          // UDPATING USER INFO UDPATING USER INFO UDPATING
          if (tabToOpen == 1) {
            List<String>? infoFields = await myDb.updateInfoFields(
                user.userId,
                nameCont.text,
                descriptionCont.text,
                locationCont.text,
                ageCont);
            if (infoFields != null) {
              googleSignFunction.refreshNameAndDesc(
                  infoFields[0], infoFields[1], infoFields[2], infoFields[3]);
            }
            editUserFunction.checkEmptiness(descriptionCont.text, nameCont.text,
                ageCont, locationCont.text);
          }
          // UDPATING SKILL BOXES  UDPATING SKILL BOXES
          if (tabToOpen == 2) {
            List<Map<String, int>>? newBoxes = await myDb.updateSkillBoxes(
                user.userId, editUserFunction.skillBoxes);
            if (newBoxes != null) {
              googleSignFunction.refreshSkillSet(editUserFunction.skillBoxes);
            }
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
