import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget textFormField(isTextObscured, myEndingIcon, myController, myHintText,
        myPrefixIcon, myKeyboardType, validator) =>
    TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Wpisz Tekst';
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
      contentPadding: const EdgeInsets.all(8),
      counterStyle: GoogleFonts.overpass(color: Colors.white),
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
