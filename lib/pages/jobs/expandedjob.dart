import 'package:flutter/material.dart';
import 'package:prakty/main.dart';

class JobAdvertisement extends StatelessWidget {
  const JobAdvertisement({super.key, this.internshipInfo});
  final internshipInfo;

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return Scaffold(
        body: SafeArea(
            child: Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          gradient: const LinearGradient(colors: gradient),
          borderRadius: BorderRadius.circular(16)),
      child: Stack(
        children: [
          ListView(children: [
            if (args['jobImage'] != null)
              // SizedBox(child: ,)
              ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(args['jobImage'],
                      height: 220, fit: BoxFit.cover)),
          ]),
          Container(
            width: 40,
            height: 52,
            decoration: BoxDecoration(
                color: args['jobImage'] != null
                    ? const Color.fromARGB(255, 49, 182, 209)
                    : Colors.transparent,
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(20),
                )),
            child: IconButton(
                alignment: Alignment.topLeft,
                iconSize: 34,
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white)),
          ),
        ],
      ),
    )));
  }
}
