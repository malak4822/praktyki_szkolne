import 'package:flutter/material.dart';
import 'package:prakty/main.dart';
import 'package:prakty/providers/edituser.dart';
import 'package:prakty/providers/googlesign.dart';
import 'package:prakty/widgets/inputwindows.dart';
import 'package:provider/provider.dart';

class EditPopUpParent extends StatefulWidget {
  const EditPopUpParent({super.key, required this.openWidgetIndex});

  final int openWidgetIndex;

  @override
  State<EditPopUpParent> createState() => _EditPopUpParentState();
}

class _EditPopUpParentState extends State<EditPopUpParent> {
  final TextEditingController nameCont = TextEditingController();
  final TextEditingController mailCont = TextEditingController();
  final TextEditingController passCont = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var editUserProvider = Provider.of<EditUser>(context);
    var googleSingInProvider = Provider.of<GoogleSignInProvider>(context);

    List<Widget> editWidgetTypes = [
      editUserNameDescriptionPassword(),
      editSkillSet(),
      editPhoto(),
    ];

    return Stack(children: [
      InkWell(
          onTap: () => editUserProvider.toogleEditingPopUp(null),
          child: Container(
              color: Colors.white.withOpacity(0.7),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                    height: MediaQuery.of(context).size.height * 4 / 5,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(colors: gradient),
                        borderRadius: BorderRadius.vertical(
                            top: Radius.elliptical(200, 40))),
                    child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: editWidgetTypes[widget.openWidgetIndex])),
              )))
    ]);
  }

  Widget editUserNameDescriptionPassword() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        updateValues(nameCont),
        const SizedBox(height: 8),
        updateValues(mailCont),
      ],
    );
  }

  Widget editPhoto() {
    return const Column(
      children: [Text('SOME PHOTO HERE')],
    );
  }

  Widget editSkillSet() {
    return Column(
      children: [
        ListView.builder(
            shrinkWrap: true,
            itemCount: 4,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) => Container(
                  color: Colors.red,
                  width: 100,
                  height: 140,
                  margin: const EdgeInsets.all(8),
                ))
      ],
    );
  }
}
