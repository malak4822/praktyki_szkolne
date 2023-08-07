import 'package:flutter/material.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 14,
      itemBuilder: (context, index) {
        // final item = items[index];

        return ListTile(
          // title: item.buildTitle(context),
          // subtitle: item.buildSubtitle(context),
        );
      },
    );
  }
}
