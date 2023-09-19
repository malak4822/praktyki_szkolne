import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prakty/main.dart';
import 'package:prakty/providers/googlesign.dart';
import 'package:prakty/widgets/inputwindows.dart';
import 'package:provider/provider.dart';
import '../../providers/edituser.dart';
import '../../providers/loginconstrains.dart';
import '../../services/database.dart';

class EditNameAndDesc extends StatelessWidget {
  const EditNameAndDesc({super.key});

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<GoogleSignInProvider>(context).getCurrentUser;

    final TextEditingController nameCont =
        TextEditingController(text: user.username);

    final TextEditingController descriptionCont =
        TextEditingController(text: user.description);

    final TextEditingController locationCont =
        TextEditingController(text: user.location);

    final ageCont = FixedExtentScrollController(initialItem: user.age);
    var editUserFunction = Provider.of<EditUser>(context, listen: false);

    return Padding(
        padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
        child: ListView(
          children: [
            updateValues(nameCont, 'Imię I Nazwisko', 1, 24),
            const SizedBox(height: 6),
            updateValues(descriptionCont, 'Opis', 8, 500),
            const SizedBox(height: 6),
            updateValues(locationCont, 'Lokalizacja', 1, 40),
            Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 1),
                    borderRadius: BorderRadius.circular(25)),
                child: CupertinoPicker(
                    looping: true,
                    scrollController: ageCont,
                    itemExtent: 20,
                    onSelectedItemChanged: (int index) {},
                    children: List.generate(
                      41,
                      (index) =>
                          Text('${index.toString()} lat', style: fontSize16),
                    ))),
            IconButton(
                onPressed: () async {
                  editUserFunction.changeLoading();
                  if (await Provider.of<LoginConstrains>(context, listen: false)
                      .checkInternetConnectivity()) {
                    // ignore: use_build_context_synchronously
                    await MyDb().updateNameAndDescription(
                        user.userId,
                        nameCont.text,
                        descriptionCont.text,
                        locationCont.text,
                        ageCont.selectedItem,
                        context);

                    editUserFunction.toogleEditingPopUp(0);
                    editUserFunction.checkEmptiness(
                        descriptionCont.text.isEmpty, nameCont.text.isEmpty);
                  }
                  editUserFunction.changeLoading();
                },
                icon: const Icon(size: 38, Icons.done, color: Colors.white)),
          ],
        ));
  }
}
