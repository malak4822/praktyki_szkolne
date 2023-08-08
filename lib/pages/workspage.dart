import 'package:flutter/material.dart';

class WorksPage extends StatelessWidget {
  const WorksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 14,
      itemBuilder: (context, index) {
        // final item = items[index];

        return const ListTile(
            // title: item.buildTitle(context),
            // subtitle: item.buildSubtitle(context),
            );
      },
    );
  }
}
