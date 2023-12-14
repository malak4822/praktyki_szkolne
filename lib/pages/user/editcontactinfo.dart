import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prakty/constants.dart';
import 'package:prakty/providers/googlesign.dart';
import 'package:prakty/widgets/inputwindows.dart';
import 'package:provider/provider.dart';

class EditContactInfo extends StatefulWidget {
  const EditContactInfo(this.emailCont, this.passCont, this.phoneCont,
      this.formKey, this.isAccountTypeUser,
      {super.key});

  final TextEditingController emailCont;
  final TextEditingController passCont;
  final TextEditingController phoneCont;
  final GlobalKey<FormState> formKey;
  final bool isAccountTypeUser;

  @override
  State<EditContactInfo> createState() => _EditContactInfoState();
}

class _EditContactInfoState extends State<EditContactInfo> {
  bool isUserVerified = false;
  bool isErrorMessageVisible = false;
  String errorMessage = '';
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 0, 30, 20),
      child: Form(
          key: widget.formKey,
          child: Center(
              child: ListView(shrinkWrap: true, children: [
            if (!widget.isAccountTypeUser)
              TextFormField(
                  style: fontSize16,
                  obscureText: true,
                  controller: widget.passCont,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: 'Wpisz Hasło',
                    hintStyle: fontSize16,
                    suffixIconColor: Colors.white,
                    suffixIcon: IconButton(
                      iconSize: 28,
                      icon: const Icon(Icons.done),
                      onPressed: () async {
                        await Provider.of<GoogleSignInProvider>(context,
                                listen: false)
                            .authenticateUser(
                                widget.passCont.text, widget.emailCont.text,
                                (bool isUserVerif, String errorMess) {
                          errorMessage = errorMess;
                          setState(() {
                            isUserVerified = isUserVerif;

                            if (isUserVerified == false) {
                              isErrorMessageVisible = true;
                            } else {
                              isErrorMessageVisible = false;
                            }
                          });
                        });
                      },
                    ),
                    icon: const Icon(Icons.key_rounded,
                        color: Colors.white, size: 24),
                    iconColor: Colors.white,
                    contentPadding: const EdgeInsets.only(left: 42),
                    counterStyle: fontSize16,
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(width: 4, color: Colors.white),
                        borderRadius: BorderRadius.all(Radius.circular(28))),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Colors.white),
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                    disabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(width: 2, color: Colors.white38),
                      borderRadius: BorderRadius.all(
                        Radius.circular(16),
                      ),
                    ),
                  )),
            AnimatedContainer(
              height: isErrorMessageVisible ? 20 : 0,
              duration: const Duration(milliseconds: 300),
              child: Padding(
                  padding: const EdgeInsets.only(left: 24),
                  child: Text(errorMessage,
                      textAlign: TextAlign.center, style: fontSize16)),
            ),
            const SizedBox(height: 16),
            TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Wpisz Nowy Email';
                  } else if (!RegExp(
                          r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                      .hasMatch(value)) {
                    return 'Wpisz Poprawny E-mail';
                  }
                  return null;
                },
                style: widget.isAccountTypeUser
                    ? fontSize16
                    : isUserVerified
                        ? fontSize16
                        : GoogleFonts.overpass(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white38),
                controller: widget.emailCont,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: 'Wpisz Email Kontaktowy',
                  hintStyle: fontSize16,
                  icon: const Icon(Icons.email, color: Colors.white),
                  iconColor: Colors.white,
                  contentPadding: EdgeInsets.zero,
                  counterStyle: fontSize16,
                  focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(width: 4, color: Colors.white),
                      borderRadius: BorderRadius.all(Radius.circular(28))),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Colors.white),
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                  disabledBorder: widget.isAccountTypeUser
                      ? const OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 2, color: Colors.white38),
                          borderRadius: BorderRadius.all(
                            Radius.circular(16),
                          ),
                        )
                      : const OutlineInputBorder(),
                  enabled: widget.isAccountTypeUser ? true : isUserVerified,
                )),
            const SizedBox(height: 16),
            updateValues(widget.phoneCont, 'Telefon', 1, 9, Icons.phone,
                TextInputType.phone, null)
          ]))),
    );
  }
}
