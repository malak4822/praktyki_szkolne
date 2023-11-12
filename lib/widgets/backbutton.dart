import 'package:flutter/material.dart';

Widget backButton(context) => Container(
      width: 52,
      height: 52,
      decoration: const BoxDecoration(
          color: Color.fromARGB(255, 49, 182, 209),
          borderRadius: BorderRadius.only(bottomRight: Radius.circular(50))),
      child: IconButton(
          alignment: Alignment.topLeft,
          iconSize: 28,
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white)),
    );
