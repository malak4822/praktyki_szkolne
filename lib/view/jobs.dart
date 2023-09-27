import 'package:flutter/material.dart';
import 'package:prakty/widgets/jobcard.dart';

class JobNoticesPage extends StatelessWidget {
  const JobNoticesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
        floatingActionButton: FloatingActionButton(
            onPressed: () => Navigator.pushNamed(context, '/addJob'),
            child: const Icon(Icons.add)),
        body: Stack(children: [
          Container(
              padding: const EdgeInsets.only(bottom: 10),
              child: ListView.builder(
                clipBehavior: Clip.none,
                itemCount: 2,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return const JobNotice();
                },
              )),
        ]));
  }
}
