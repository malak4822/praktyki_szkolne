import 'package:flutter/material.dart';
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
                blurRadius: 4),
          ],
          gradient: const LinearGradient(colors: gradient),
          borderRadius: BorderRadius.circular(8)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.star, color: Colors.white, size: 32),
          const SizedBox(height: 4),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Text(successTxt, style: fontSize16, maxLines: 1)),
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
                        height: 8,
                      ))))
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
        Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(Icons.star, color: Colors.white, size: 38),
          const SizedBox(height: 10),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Text(successTxt, style: fontSize16, maxLines: 1)),
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
                      height: 8,
                    ));
              }))
        ]),
        blackBox(2, false, chosenBox, context),
      ]));
}
