import 'package:flutter/material.dart';
import 'package:prakty/main.dart';

class FindOnMap extends StatelessWidget {
  const FindOnMap({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Stack(children: [
      Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              gradient: const LinearGradient(colors: gradient),
              borderRadius: BorderRadius.circular(16))),
      Container(
          width: 52,
          height: 52,
          decoration: const BoxDecoration(
              color: Color.fromARGB(255, 49, 182, 209),
              borderRadius:
                  BorderRadius.only(bottomRight: Radius.circular(50))),
          child: IconButton(
              alignment: Alignment.topLeft,
              iconSize: 28,
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios_rounded,
                  color: Colors.white)))
    ])));
  }
}
