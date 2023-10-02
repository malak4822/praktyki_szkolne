import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prakty/providers/googlesign.dart';
import 'package:provider/provider.dart';

class MyTextFormField extends StatelessWidget {
  MyTextFormField(
      {super.key,
      required this.isTextObscured,
      this.myEndingIcon,
      required this.myController,
      required this.myHintText,
      this.myPrefixIcon,
      required this.myKeyboardType,
      required this.fieldNumber,
      this.errorMessage});

  final bool isTextObscured;
  final dynamic myEndingIcon;
  final TextEditingController myController;
  final String myHintText;
  final Icon? myPrefixIcon;
  final TextInputType myKeyboardType;
  final int fieldNumber;
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        void getMessage() {
          print(errorMessage);
          errorMessage =
              Provider.of<GoogleSignInProvider>(context, listen: false)
                  .errorMessage;
          print(errorMessage);
        }

        getMessage();
        if (value == null || value.isEmpty) {
          return 'Wpisz Tekst';
        } else if (fieldNumber == 1) {
          if (errorMessage == 'invalid-email') {
            print('EMAIL JEST ZŁY W FORM FIELD');
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

// Widget textFormField(isTextObscured, myEndingIcon, myController, myHintText,
//     myPrefixIcon, myKeyboardType, fieldNumber, context) {
//   String errorMessage = '';

//   return TextFormField(
//     validator: (value) {
//       void getMessage() {
//         print(errorMessage);
//         Provider.of<GoogleSignInProvider>(context, listen: false).errorMessage;
//         print(errorMessage);
//       }

//       getMessage();
//       if (value == null || value.isEmpty) {
//         return 'Wpisz Tekst';
//       } else if (fieldNumber == 1) {
//         if (errorMessage == 'invalid-email') {
//           print('EMAIL JEST ZŁY W FORM FIELD');
//           return 'Niepoprawny Email';
//         } else if (errorMessage == 'user-not-found') {
//           return 'Nie Ma Takiego Użytkownika';
//         }
//       } else if (fieldNumber == 2 && errorMessage == 'wrong-password') {
//         return 'Niepoprawne Hasło';
//       }
//       return null;
//     },
//     cursorColor: Colors.white,
//     obscureText: isTextObscured,
//     textInputAction: TextInputAction.next,
//     style:
//         GoogleFonts.overpass(fontWeight: FontWeight.bold, color: Colors.white),
//     keyboardType: myKeyboardType,
//     controller: myController,
//     decoration: InputDecoration(
//       prefixIconColor: Colors.white,
//       suffixIcon: myEndingIcon,
//       prefixIcon: myPrefixIcon,
//       enabledBorder: const OutlineInputBorder(
//           borderSide: BorderSide(width: 2, color: Colors.white),
//           borderRadius: BorderRadius.all(Radius.circular(15))),
//       focusedBorder: const OutlineInputBorder(
//           borderSide: BorderSide(width: 4, color: Colors.white),
//           borderRadius: BorderRadius.all(Radius.circular(30))),
//       border: const OutlineInputBorder(
//         borderRadius: BorderRadius.all(Radius.circular(15)),
//       ),
//       hintText: myHintText,
//       hintStyle: GoogleFonts.overpass(
//           fontWeight: FontWeight.bold, color: Colors.white),
//     ),
//   );
// }

Widget updateValues(myController, hintTxt, maxLines, maxLength, icon) {
  return TextField(
    textAlign: TextAlign.center,
    maxLength: maxLength,
    maxLines: maxLines,
    cursorColor: Colors.white,
    style:
        GoogleFonts.overpass(fontWeight: FontWeight.bold, color: Colors.white),
    controller: myController,
    decoration: InputDecoration(
      icon: Icon(icon),
      iconColor: Colors.white,
      contentPadding: const EdgeInsets.only(right: 8),
      counterStyle: GoogleFonts.overpass(color: Colors.white, height: 1),
      focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(width: 4, color: Colors.white),
          borderRadius: BorderRadius.all(Radius.circular(25))),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(width: 1, color: Colors.white),
        borderRadius: BorderRadius.all(Radius.circular(25)),
      ),
      hintText: hintTxt,
      hintStyle: GoogleFonts.overpass(
          fontWeight: FontWeight.bold, color: Colors.white),
    ),
  );
}
