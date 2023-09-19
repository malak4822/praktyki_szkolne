import 'package:flutter/material.dart';
import 'package:prakty/main.dart';
import 'package:prakty/providers/edituser.dart';
import 'package:prakty/widgets/editprofwidgets/editskillset.dart';
import 'package:provider/provider.dart';
import '../providers/googlesign.dart';
import '../providers/loginconstrains.dart';
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
    var googleSignFunction =
        Provider.of<GoogleSignInProvider>(context, listen: false);

    Future<bool> internetCheck =
        Provider.of<LoginConstrains>(context, listen: false)
            .checkInternetConnectivity();

    List<Widget> editWidgetTypes = [
      const EditPhoto(),
      const EditNameAndDesc(),
      const EditSkillSet(),
    ];

    return Column(children: [
      Expanded(child: GestureDetector(onTap: () async {
        // Closing Skillset Widget
        if (tabToOpen == 2) {
          editUserFunction.changeLoading();
          try {
            await MyDb().updateSkillBoxes(
                googleSignFunction.getCurrentUser.userId,
                editUserFunction.skillBoxes,
                context);
          } catch (e) {
            debugPrint(e.toString());
          }
          editUserFunction.changeLoading();
        }
        // Closing Photo Widget
        if (tabToOpen == 0) {
          editUserFunction.changeLoading();

          if (await internetCheck) {
            var newUrlString = await MyDb().uploadImageToStorage(
                googleSignFunction.getCurrentUser.userId,
                editUserFunction.imgFile);
            if (newUrlString != null) {
              googleSignFunction.refreshProfilePicture(newUrlString);
            }
          }
          editUserFunction.changeLoading();

          editUserFunction.deleteSelectedImage();
        }
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
