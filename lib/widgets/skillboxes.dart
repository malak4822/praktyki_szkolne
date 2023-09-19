import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main.dart';
import '../pages/edituserpage.dart';

Widget skillBox(successTxt, skillLevel, context, bool isChosen) => Container(
      margin: const EdgeInsets.all(6),
      width: MediaQuery.of(context).size.width / 4,
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: isChosen ? Colors.black54 : Colors.white,
                spreadRadius: 0.3,
                blurRadius: 4)
          ],
          gradient: const LinearGradient(colors: gradient),
          borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          const Spacer(flex: 2),
          const Icon(Icons.star, color: Colors.white, size: 32),
          const Spacer(),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Text(successTxt,
                  style: GoogleFonts.overpass(
                      fontSize: 16,
                      height: 1,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  maxLines: 3,
                  textAlign: TextAlign.center)),
          const SizedBox(height: 3),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                  skillLevel,
                  (index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 1),
                      child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: 8,
                          height: 8)))),
          const Spacer(flex: 3),
        ],
      ),
    );

Widget skillEditBox(String successTxt, int skillLevel, int chosenBox, context) {
  return Container(
      height: 120,
      margin: const EdgeInsets.all(6),
      width: MediaQuery.of(context).size.width / 4,
      decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(color: Colors.black54, spreadRadius: 0.3, blurRadius: 5)
          ],
          gradient: const LinearGradient(colors: gradient),
          borderRadius: BorderRadius.circular(8)),
      child: Stack(children: [
        Column(children: [
          const Spacer(flex: 2),
          const Icon(Icons.star, color: Colors.white, size: 32),
          const Spacer(),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Text(successTxt,
                  style: GoogleFonts.overpass(
                      fontSize: 16,
                      height: 1,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  maxLines: 3,
                  textAlign: TextAlign.center)),
          const SizedBox(height: 3),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(skillLevel, (index) {
                return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 1),
                    child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        width: 8,
                        height: 8));
              })),
          const Spacer(flex: 3),
        ]),
        blackBox(2, false, chosenBox, context),
      ]));
}
