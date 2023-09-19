import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget logPut(isTextObscured, myEndingIcon, myController, myHintText,
    myPrefixIcon, myKeyboardType, context) {
  return Stack(
    children: [
      TextField(
        onChanged: (newValue) {},
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
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 4, color: Colors.white),
              borderRadius: BorderRadius.all(Radius.circular(25))),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(25)),
          ),
          hintText: myHintText,
          hintStyle: GoogleFonts.overpass(fontWeight: FontWeight.bold),
        ),
      )
    ],
  );
}

Widget updateValues(myController, hintTxt, maxLines, maxLength) {
  return TextField(
    textAlign: TextAlign.center,
    maxLength: maxLength,
    maxLines: maxLines,
    cursorColor: Colors.white,
    style:
        GoogleFonts.overpass(fontWeight: FontWeight.bold, color: Colors.white),
    controller: myController,
    decoration: InputDecoration(
      contentPadding: const EdgeInsets.all(10),
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
