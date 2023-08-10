import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget logPut(isTextObscured, myEndingIcon, myController, myHintText,
    myPrefixIcon, myKeyboardType, context) {
  return
      // ConstrainedBox(
      // constraints: BoxConstraints(maxWidth: boxWidth),
      // child:
      Stack(
    children: [
      // AnimatedContainer(
      //   duration: const Duration(milliseconds: 800),
      //   decoration: const BoxDecoration(
      //     borderRadius: BorderRadius.horizontal(
      //         right: Radius.circular(50), left: Radius.circular(40)),
      //     color: Colors.white38,
      //   ),
      //   width: fillFieldLvl,
      // ),
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
              borderSide: BorderSide(width: 2, color: Colors.white),
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

Widget updateValues(myController) {
  return TextField(
    cursorColor: Colors.white,
    textInputAction: TextInputAction.next,
    style:
        GoogleFonts.overpass(fontWeight: FontWeight.bold, color: Colors.white),
    controller: myController,
    decoration: InputDecoration(
      prefixIconColor: Colors.white,
      focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(width: 2, color: Colors.white),
          borderRadius: BorderRadius.all(Radius.circular(25))),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(25)),
      ),
      hintStyle: GoogleFonts.overpass(fontWeight: FontWeight.bold),
    ),
  );
}
