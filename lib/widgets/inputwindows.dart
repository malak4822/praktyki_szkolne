import 'package:animated_icon_button/animated_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget logPut(isTextObscured, widget, myController, myHintText, myPrefixIcon,
        myKeyboardType) =>
    Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: TextField(
          cursorColor: Colors.white,
          obscureText: isTextObscured,
          textInputAction: TextInputAction.next,
          style: GoogleFonts.overpass(fontWeight: FontWeight.bold),
          keyboardType: myKeyboardType,
          controller: myController,
          decoration: InputDecoration(
            prefixIconColor: Colors.white,
            fillColor: const Color.fromARGB(89, 255, 255, 255),
            suffixIcon: widget,
            prefixIcon: myPrefixIcon,
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
            ),
            filled: true,
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            hintText: myHintText,
            hintStyle: GoogleFonts.overpass(fontWeight: FontWeight.bold),
          ),
        ));
