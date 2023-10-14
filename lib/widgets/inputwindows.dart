import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prakty/providers/googlesign.dart';
import 'package:provider/provider.dart';

class MyTextFormField extends StatelessWidget {
  const MyTextFormField({
    super.key,
    required this.isTextObscured,
    this.myEndingIcon,
    required this.myController,
    required this.myHintText,
    this.myPrefixIcon,
    required this.myKeyboardType,
    required this.fieldNumber,
  });

  final bool isTextObscured;
  final dynamic myEndingIcon;
  final TextEditingController myController;
  final String myHintText;
  final Icon? myPrefixIcon;
  final TextInputType myKeyboardType;
  final int fieldNumber;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        String errorMessage = '';
        void getMessage() {
          errorMessage =
              Provider.of<GoogleSignInProvider>(context, listen: false)
                  .errorMessage;
        }

        getMessage();
        if (value == null || value.isEmpty) {
          return 'Wpisz Tekst';
        } else if (fieldNumber == 1) {
          if (errorMessage == 'invalid-email') {
            return 'Niepoprawny Email';
          } else if (errorMessage == 'user-not-found') {
            return 'Nie Ma Takiego Użytkownika';
          }
        } else if (fieldNumber == 2 && errorMessage == 'wrong-password') {
          return 'Niepoprawne Hasło';
        }
        return null;
      },
      cursorColor: Colors.white,
      obscureText: isTextObscured,
      textInputAction: TextInputAction.next,
      style: GoogleFonts.overpass(
          fontWeight: FontWeight.bold, color: Colors.white),
      keyboardType: myKeyboardType,
      controller: myController,
      decoration: InputDecoration(
        prefixIconColor: Colors.white,
        suffixIcon: myEndingIcon,
        prefixIcon: myPrefixIcon,
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: Colors.white),
            borderRadius: BorderRadius.all(Radius.circular(15))),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(width: 4, color: Colors.white),
            borderRadius: BorderRadius.all(Radius.circular(30))),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        hintText: myHintText,
        hintStyle: GoogleFonts.overpass(
            fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }
}

Widget updateValues(myController, hintTxt, maxLines, maxLength, icon,
    myKeyboardType, callBack) {
  return TextFormField(
    onTap: () {
      if (hintTxt == 'Miejsce') {
        callBack();
      }
    },
    focusNode: hintTxt != 'Miejsce' ? FocusNode(canRequestFocus: true) : FocusScopeNode(),
    validator: (val) {
      if (val!.isEmpty) {
        return 'Proszę Uzupełnić Puste Pole';
      } else if (val.length < 7) {
        return 'Liczba Znaków Jest Za Mała';
      }
      if (hintTxt == 'Email Kontaktowy') {
        if (!val.contains('@') || val.length < 7) {
          return 'Email Jest Nie Poprawny';
        }
      }
      if (hintTxt == 'Telefon') {
        if (val.length != 9) {
          return 'Telefon Nie Ma 9 Cyfr';
        }
      }
      return null;
    },
    textAlign: TextAlign.center,
    maxLength: maxLength,
    maxLines: maxLines,
    keyboardType: myKeyboardType,
    cursorColor: Colors.white,
    style:
        GoogleFonts.overpass(fontWeight: FontWeight.bold, color: Colors.white),
    controller: myController,
    decoration: InputDecoration(
      icon: Icon(icon),
      iconColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      counterStyle: GoogleFonts.overpass(color: Colors.white, height: 0.4),
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
      hintText: hintTxt,
      hintStyle: GoogleFonts.overpass(
          fontWeight: FontWeight.bold, color: Colors.white),
    ),
  );
}
