import 'package:flutter/material.dart';
import 'package:prakty/widgets/inputwindows.dart';

class EditContactInfo extends StatelessWidget {
  const EditContactInfo(this.emailCont, this.phoneCont, this.formKey,
      {super.key});

  final TextEditingController emailCont;
  final TextEditingController phoneCont;
  final  formKey;

  // final formKeye = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
      child: Form(
          key: formKey,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            updateValues(emailCont, 'Email', 1, 24, Icons.email,
                TextInputType.emailAddress, null),
            const SizedBox(height: 10),
            updateValues(phoneCont, 'Telefon', 1, 9, Icons.phone,
                TextInputType.phone, null),
            // ElevatedButton(
            //     onPressed: () {
            //       if (formKeye.currentState?.validate() ?? false) {
            //         print('Form is valid');
            //       } else {
            //         print('ISNO T VALUID');
            //       }
            //     },
            //     child: Text("EEEEEEEEEEESA"))
          ])),
    );
  }
}
