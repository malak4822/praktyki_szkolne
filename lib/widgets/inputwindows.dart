import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prakty/providers/functions.dart';
import 'package:provider/provider.dart';

Widget logPut(isTextObscured, widget, myController, myHintText, myPrefixIcon,
    myKeyboardType, context) {
  double fillFieldLvl = Provider.of<Functions>(context).fillFieldLvl;
  double boxWidth = MediaQuery.of(context).size.width * 4 / 5;
  bool see = Provider.of<Functions>(context).aa;
  return ConstrainedBox(
      constraints:
          BoxConstraints(maxWidth: boxWidth, minHeight: 60, maxHeight: 60),
      child: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 800),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.horizontal(
                  right: Radius.circular(50), left: Radius.circular(25)),
              color: see ? Colors.green : Colors.white38,
            ),
            width: fillFieldLvl,
          ),
          TextField(
            onChanged: (newValue) {
              Provider.of<Functions>(context, listen: false).lvlUp(boxWidth);
            },
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
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                  borderSide: BorderSide(color: Colors.white)),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
              hintText: myHintText,
              hintStyle: GoogleFonts.overpass(fontWeight: FontWeight.bold),
            ),
          )
        ],
      ));
}
