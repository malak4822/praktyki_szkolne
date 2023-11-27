import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants.dart';

Widget contactBox(icon, String command, bool notToEdit) => Container(
      height: 72,
      width: 72,
      decoration: BoxDecoration(
          gradient: const LinearGradient(colors: gradient),
          borderRadius: BorderRadius.circular(16),
          boxShadow: myBoxShadow),
      child: ElevatedButton.icon(
        label: const SizedBox(),
        onPressed: () async {
          if (command != '') {
            !await launchUrl(Uri.parse(command));
          }
        },
        style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.only(left: 20, right: 12),
            backgroundColor: notToEdit ? Colors.transparent : Colors.black45,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16))),
        icon: Icon(icon,
            size: 30, color: notToEdit ? Colors.white : Colors.white38),
      ),
    );
