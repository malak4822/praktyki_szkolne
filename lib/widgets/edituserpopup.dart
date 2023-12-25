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

    int? ageCont = user.age;

    final TextEditingController nameCont =
        TextEditingController(text: user.username);

    final TextEditingController descriptionCont =
        TextEditingController(text: user.description);

    final TextEditingController locationCont =
        TextEditingController(text: user.location);

// CONTACT CONTROLLERS
    final TextEditingController emailCont =
        TextEditingController(text: user.email);

    final TextEditingController passCont = TextEditingController();

    final TextEditingController phoneCont =
        TextEditingController(text: user.phoneNum);

    final formKeyPhone = GlobalKey<FormState>();
    final formKeyDesc = GlobalKey<FormState>();

    List<Widget> editWidgetTypes = [
      EditPhoto(user: user),
      EditNameAndDesc(
          nameCont,
          descriptionCont,
          locationCont,
          emailCont,
          ageCont!,
          (newVal) => ageCont = newVal,
          user.isAccountTypeUser,
          formKeyDesc),
      const EditSkillSet(),
      EditContactInfo(
          emailCont, passCont, phoneCont, formKeyPhone, user.isAccountTypeUser)
    ];

    return Column(children: [
      Expanded(child: GestureDetector(onTap: () async {
        MyDb myDb = MyDb();

        if (await editUserFunction.checkInternetConnectivity()) {
          if (tabToOpen != 3 && tabToOpen != 1) {
            editUserFunction.changeLoading();
          }
          // UPDATING PHOTO UPDATING PHOTO UPDATING PHOTO
          if (tabToOpen == 0) {
            if (editUserFunction.imgFile?.path != 'freshImage') {
              var uploadUrl = await myDb.uploadImageToStorage(
                  user.userId, editUserFunction.imgFile);

              googleSignFunction.refreshProfilePicture(uploadUrl);

              editUserFunction.deleteSelectedImage();
            }
          }

          // UDPATING USER INFO UDPATING USER INFO UDPATING
          if (tabToOpen == 1) {
            if (formKeyDesc.currentState?.validate() ?? false) {
              editUserFunction.changeLoading();
              List<String>? infoFields = await myDb.updateInfoFields(
                  user.userId,
                  nameCont.text,
                  descriptionCont.text,
                  locationCont.text,
                  ageCont!);
              if (infoFields != null) {
                googleSignFunction.refreshNameAndDesc(
                    infoFields[0], infoFields[1], infoFields[2], infoFields[3]);
                editUserFunction.toogleEditingPopUp(3);
              }
              if (user.isAccountTypeUser) {
                editUserFunction.checkEmptiness(descriptionCont.text,
                    nameCont.text, ageCont!, locationCont.text);
              } else {
                editUserFunction.checkEmptiness(
                    descriptionCont.text, nameCont.text, 1, 'a');
              }
              editUserFunction.changeLoading();
            }
          }
          // UDPATING SKILL BOXES UDPATING SKILL BOXES
          else if (tabToOpen == 2) {
            List<Map<String, int>>? newBoxes = await myDb.updateSkillBoxes(
                user.userId, editUserFunction.skillBoxes);
            if (newBoxes != null) {
              googleSignFunction.refreshSkillSet(editUserFunction.skillBoxes);
            }
            // UDPATING PHONE CONTACT UDPATING PHONE
          } else if (tabToOpen == 3) {
            if (formKeyPhone.currentState?.validate() ?? false) {
              editUserFunction.changeLoading();

              if (!mounted) return;
              var userCredentials =
                  Provider.of<GoogleSignInProvider>(context, listen: false)
                      .auth
                      .currentUser;

              List<String>? infoFields = await myDb.updateContactInfo(
                  emailCont.text, phoneCont.text, userCredentials!);
              if (infoFields != null) {
                googleSignFunction.refreshContactInfo(
                    infoFields[0], infoFields[1]);
              }

              editUserFunction.toogleEditingPopUp(3);
              editUserFunction.changeLoading();
            }
          }
        }
        if (tabToOpen != 3 && tabToOpen != 1) {
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
