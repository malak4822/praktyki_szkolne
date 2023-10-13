import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final fontSize20 = GoogleFonts.overpass(
    fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white);
final fontSize16 = GoogleFonts.overpass(
    fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white);

const List<Color> gradient = [
  Color.fromARGB(255, 1, 192, 209),
  Color.fromARGB(255, 0, 82, 156)
];

// const List<Color> gradient = [
//   Colors.amber, // Yellow
//   Colors.purpleAccent, // Purple
// ];

// const List<Color> gradient = [
//   Colors.purple,
//   Colors.blue,
// ];

const myBoxShadow = [
  BoxShadow(
    color: Colors.black54,
    spreadRadius: 0.3,
    blurRadius: 5,
  )
];

const myOutlineBoxShadow = [
  BoxShadow(
      color: Colors.black54,
      spreadRadius: 0.3,
      blurRadius: 5,
      blurStyle: BlurStyle.outer)
];
