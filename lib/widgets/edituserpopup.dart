import 'package:flutter/material.dart';
import 'package:prakty/constants.dart';
import 'package:prakty/pages/user/editcontactinfo.dart';
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

    final TextEditingController locationCont =
        TextEditingController(text: user.location);

// CONTACT CONTROLLERS
    final TextEditingController emailCont =
        TextEditingController(text: user.email);

    final TextEditingController phoneCont =
        TextEditingController(text: user.phoneNum);

    final formKey = GlobalKey<FormState>();

    List<Widget> editWidgetTypes = [
      EditPhoto(user: user),
      EditNameAndDesc(nameCont, descriptionCont, locationCont, emailCont,
          ageCont, (newVal) => ageCont = newVal, user.isAccountTypeUser),
      const EditSkillSet(),
      EditContactInfo(emailCont, phoneCont, formKey)
    ];

    return Column(children: [
      Expanded(child: GestureDetector(onTap: () async {
        MyDb myDb = MyDb();

        // UDPATING CONTACT INFORMATIONS
        if (tabToOpen == 3) {
          // if (phoneCont.text.isNotEmpty) {
          if (formKey.currentState?.validate() ?? false) {
            editUserFunction.changeLoading();
            List<String>? infoFields = await myDb.updateContactInfo(
                user.userId, emailCont.text, phoneCont.text);
            if (infoFields != null) {
              googleSignFunction.refreshContactInfo(
                  infoFields[0], infoFields[1]);
              editUserFunction.toogleEditingPopUp(3);
            }
            editUserFunction.changeLoading();
          }
          // } else {
          //   editUserFunction.toogleEditingPopUp(3);
          // }
        } else {
          editUserFunction.changeLoading();
        }

        if (await editUserFunction.checkInternetConnectivity()) {
          // UPDATING PHOTO UPDATING PHOTO UPDATING PHOTO
          if (tabToOpen == 0) {
            // if (editUserFunction.imgFile == null) {
            //   googleSignFunction.refreshProfilePicture(
            //       'https://firebasestorage.googleapis.com/v0/b/praktyki-szkolne.appspot.com/o/my_files%2Fman_praktyki.png?alt=media&token=dec782e2-1e50-4066-b0b6-0dc8019463d8&_gl=1*5iyx8e*_ga*MTg3NTU1MzM0MC4xNjk4MzAyMTM5*_ga_CW55HF8NVT*MTY5OTI4NjY4OC42LjEuMTY5OTI4NjcwMS40Ny4wLjA.');
            // }
            var newUrlString = await myDb.uploadImageToStorage(
                user.userId, editUserFunction.imgFile);
            if (newUrlString == 'freshImage') {
              print('was Fresh Af');
            } else if (newUrlString != null) {
              print('ess');
              googleSignFunction.refreshProfilePicture(newUrlString);
            } else {
              print('essssssssssssss');
              googleSignFunction.refreshProfilePicture(
                  'https://firebasestorage.googleapis.com/v0/b/praktyki-szkolne.appspot.com/o/my_files%2Fman_praktyki.png?alt=media&token=dec782e2-1e50-4066-b0b6-0dc8019463d8&_gl=1*5iyx8e*_ga*MTg3NTU1MzM0MC4xNjk4MzAyMTM5*_ga_CW55HF8NVT*MTY5OTI4NjY4OC42LjEuMTY5OTI4NjcwMS40Ny4wLjA.');
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
            if (user.isAccountTypeUser) {
              editUserFunction.checkEmptiness(descriptionCont.text,
                  nameCont.text, ageCont, locationCont.text);
            } else {
              editUserFunction.checkEmptiness(
                  descriptionCont.text, nameCont.text, 1, 'a');
            }
          }
          // UDPATING SKILL BOXES UDPATING SKILL BOXES
          if (tabToOpen == 2) {
            List<Map<String, int>>? newBoxes = await myDb.updateSkillBoxes(
                user.userId, editUserFunction.skillBoxes);
            if (newBoxes != null) {
              googleSignFunction.refreshSkillSet(editUserFunction.skillBoxes);
            }
          }
        }
        if (tabToOpen != 3) {
          editUserFunction.changeLoading();
          editUserFunction.toogleEditingPopUp(3);
        }
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
