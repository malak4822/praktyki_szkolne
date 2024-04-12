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
  });

  final bool isTextObscured;
  final dynamic myEndingIcon;
  final TextEditingController myController;
  final String myHintText;
  final Icon? myPrefixIcon;
  final TextInputType myKeyboardType;

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

        // BUG - REJESTREUJE LUDZI KTÓRZY MAJĄ MNIEJ NIŻ 7 LITER W IMIENIU I NAZWISKU

        getMessage();
        if (value == null || value.isEmpty) {
          return 'Uzupełnij Pole';
        } else if (myHintText == 'Imię I Nazwisko') {
          if (value.length < 7) {
            return 'Imię I Nazwisko Jest Za Krótkie';
          }
        } else if (myHintText == 'Email') {
          if (errorMessage == 'invalid-email') {
            return 'Niepoprawny Email';
          } else if (errorMessage == 'too-many-requests') {
            return 'Zbyt Wiele Prób, Spróbuj Później';
          } else if (errorMessage == 'user-not-found') {
            return 'Nie Ma Takiego Użytkownika';
          } else if (errorMessage == 'email-already-in-use') {
            return 'Email Już Jest Zajęty';
          }
        } else if (myHintText == 'Hasło') {
          if (errorMessage == 'wrong-password') {
            return 'Zbyt Słabe Hasło, Min. 6 Znaków';
          } else if (!value.contains(RegExp(r'[A-Z]'))) {
            return 'Hasło Musi Mieć Conajmniej 1 Wielką Literę';
          } else if (errorMessage == 'weak-password') {
            return 'Hasło Musi Mieć Conajmniej 6 Znaków';
          }
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
    focusNode: hintTxt != 'Miejsce'
        ? FocusNode(canRequestFocus: true)
        : FocusScopeNode(),
    validator: (val) {
      if (hintTxt == 'Miejsce') {
      } else {
        if (val != null) {
          if (hintTxt == 'Telefon') {
            if (val.isNotEmpty) {
              if (val.length != 9) {
                return 'Telefon Nie Ma 9 Cyfr';
              }
            } else {
              if (hintTxt != 'Opis') {
                if (val.isEmpty) {
                  return 'Proszę Uzupełnić Puste Pole';
                } else if (val.length < 7) {
                  return 'Liczba Znaków Jest Za Mała';
                }
                if (val == 'Opis Stanowiska') {
                  if (val.length < 40) {
                    return 'Proszę Wpisać Minimum 40 znaków';
                  }
                }
                if (hintTxt == 'Email') {
                  if (!RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                      .hasMatch(val)) {
                    return 'Wpisz Poprawny E-mail';
                  }
                }
                if (hintTxt == 'Numer Telefonu') {
                  if (val.length != 9) {
                    return 'Telefon Nie ma 9 Cyfr';
                  }
                }
              }
            }
          }
        }
        return null;
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
        borderSide: BorderSide(width: 2, color: Colors.white),
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
