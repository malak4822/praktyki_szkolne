import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants.dart';

Widget contactBox(icon, String command, bool notToEdit, callBack) =>
    Container(
      height: 76,
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
          callBack();
        },
        style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.only(left: 24, right: 16),
            backgroundColor: notToEdit ? Colors.transparent : Colors.black45,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16))),
        icon: Icon(icon,
            size: 32, color: notToEdit ? Colors.white : Colors.white70),
      ),
    );
