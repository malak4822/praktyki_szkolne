import 'package:flutter/material.dart';
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
    var editUserFunction = Provider.of<EditUser>(context, listen: false);

    return Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            updateValues(nameCont, 'Imię I Nazwisko', 1, 24),
            const SizedBox(height: 6),
            Expanded(child: updateValues(descriptionCont, 'Opis', 14, 500)),
            IconButton(
                onPressed: () async {
                  if (await Provider.of<LoginConstrains>(context, listen: false)
                      .checkInternetConnectivity()) {
                    // ignore: use_build_context_synchronously
                    await MyDb().updateNameAndDescription(user.userId,
                        nameCont.text, descriptionCont.text, context);

                    editUserFunction.toogleEditingPopUp(0);
                    editUserFunction.checkEmptiness(
                        descriptionCont.text.isEmpty, nameCont.text.isEmpty);
                  }
                },
                icon: const Icon(size: 38, Icons.done, color: Colors.white))
          ],
        ));
  }
}
