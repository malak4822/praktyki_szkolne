import 'package:flutter/material.dart';
import 'package:prakty/widgets/inputwindows.dart';

class EditContactInfo extends StatelessWidget {
  const EditContactInfo(this.emailCont, this.phoneCont, this.formKey,
      {super.key});

  final TextEditingController emailCont;
  final TextEditingController phoneCont;
  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 0, 30, 20),
      child: Form(
          key: formKey,
          child: Center(
              child: ListView(
                shrinkWrap: true,
                  children: [
                updateValues(emailCont, 'Email', 1, null, Icons.email,
                    TextInputType.emailAddress, null),
                const SizedBox(height: 16),
                updateValues(phoneCont, 'Telefon', 1, 9, Icons.phone,
                    TextInputType.phone, null),
              ]))),
    );
  }
}
