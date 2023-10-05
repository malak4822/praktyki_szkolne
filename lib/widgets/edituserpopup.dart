import 'package:flutter/material.dart';
import 'package:prakty/main.dart';
import 'package:prakty/providers/edituser.dart';
import 'package:prakty/pages/editprofwidgets/editskillset.dart';
import 'package:provider/provider.dart';
import '../providers/googlesign.dart';
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
    Future<void> savePhoto() async {
      try {
        var newUrlString = await MyDb()
            .uploadImageToStorage(user.userId, editUserFunction.imgFile);
        if (newUrlString != null) {
          googleSignFunction.refreshProfilePicture(newUrlString);
        }
      } catch (e) {
        debugPrint(e.toString());
      }
      editUserFunction.deleteSelectedImage();
    }

    Future<void> saveInfo() async {
      try {
        await MyDb().updateInfoFields(user.userId, nameCont.text,
            descriptionCont.text, locationCont.text, ageCont, context);
        editUserFunction.checkEmptiness(
            descriptionCont.text, nameCont.text, ageCont, locationCont.text);
      } catch (e) {
        debugPrint(e.toString());
      }
    }

    Future<void> saveSkillBoxes() async {
      try {
        print(editUserFunction.skillBoxes);
        await MyDb().updateSkillBoxes(user.userId, editUserFunction.skillBoxes, context);
        if (!context.mounted) return;
        setState(() {
          print('eesa');
          user.skillsSet = editUserFunction.skillBoxes;
        });
      } catch (e) {
        debugPrint(e.toString());
      }
    }

    return Column(children: [
      Expanded(child: GestureDetector(onTap: () async {
        editUserFunction.changeLoading();

        if (await editUserFunction.checkInternetConnectivity()) {
          if (tabToOpen == 0) {
            savePhoto();
          }
          if (tabToOpen == 1) {
            saveInfo();
          }
          if (tabToOpen == 2) {
            if (!context.mounted) return;
            saveSkillBoxes();
          }
        } else {
          if (tabToOpen == 2) {
            print('RESTORING DATA');
            user.skillsSet = editUserFunction.skillBoxes;
          }
        }
        // MyDb()
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
