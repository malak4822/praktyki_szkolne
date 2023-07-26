import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prakty/providers/googlesign.dart';
import 'package:provider/provider.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var googleProvider = Provider.of<GoogleSignInProvider>(context);
    return Scaffold(
        appBar: AppBar(),
        body: ListView(children: [
          Text(
              '${googleProvider.getCurrentUser.username} \n ${googleProvider.getCurrentUser.email}',
              textAlign: TextAlign.center,
              style: GoogleFonts.overpass(
                  color: Colors.black,
                  fontSize: 26,
                  fontWeight: FontWeight.bold)),
          ElevatedButton(
              onPressed: () {
                Provider.of<GoogleSignInProvider>(context, listen: false)
                    .logout();
              },
              child: const Icon(Icons.exit_to_app))
        ]));
  }
}
