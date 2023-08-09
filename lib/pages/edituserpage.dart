import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prakty/main.dart';
import 'package:prakty/providers/googlesign.dart';
import 'package:provider/provider.dart';

import '../services/database.dart';

class EditUserPage extends StatelessWidget {
  const EditUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    var googleProvider = Provider.of<GoogleSignInProvider>(context);
    return Scaffold(
      body: ListView(
        children: [
          SizedBox(
              height: 200,
              child: Stack(children: [
                Container(
                  height: 140,
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(colors: gradient),
                      borderRadius: BorderRadius.vertical(
                          bottom: Radius.elliptical(200, 30))),
                ),
                const Align(
                    alignment: Alignment(0.9, -0.8),
                    child: Image(
                        image: AssetImage('images/menuicon.png'), height: 30)),
                Center(
                    child: Container(
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(colors: gradient)),
                        child: CircleAvatar(
                            radius: 86,
                            backgroundColor: Colors.white,
                            child: ClipOval(
                              child: FadeInImage(
                                height: 160,
                                fit: BoxFit.contain,
                                fadeInDuration:
                                    const Duration(milliseconds: 500),
                                image: NetworkImage(
                                  googleProvider
                                          .getCurrentUser.registeredViaGoogle
                                      ? googleProvider
                                          .getCurrentUser.profilePicture
                                      : 'https://assets.codepen.io/1480814/av+1.png',
                                ),
                                placeholder: const AssetImage(
                                    'https://assets.codepen.io/1480814/av+1.png'),
                              ),
                            )))),
              ])),
          Expanded(
            child: Column(
              children: [
                Text(
                  googleProvider.getCurrentUser.username,
                  softWrap: true,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.overpass(
                      color: gradient[1],
                      fontSize: 24,
                      fontWeight: FontWeight.w900),
                ),
                Text(googleProvider.getCurrentUser.description,
                    maxLines: 4,
                    style: GoogleFonts.overpass(
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.w200)),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 0, 162, 226)),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.home)),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 0, 162, 226)),
                  onPressed: () {
                    Navigator.pop(context);
                    Provider.of<GoogleSignInProvider>(context, listen: false)
                        .logout();
                  },
                  child: const Icon(Icons.exit_to_app)),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 0, 162, 226)),
                  onPressed: () async {
                    googleProvider.getCurrentUser;

                    await MyDb().getUserInfo(googleProvider.getCurrentUser);
                    debugPrint(googleProvider.getCurrentUser.username);
                    debugPrint(googleProvider.getCurrentUser.email);
                    debugPrint(googleProvider.getCurrentUser.age.toString());
                    debugPrint(
                        googleProvider.getCurrentUser.isNormalUser.toString());
                    debugPrint(googleProvider.getCurrentUser.profilePicture);
                    debugPrint(googleProvider.getCurrentUser.userId);
                    debugPrint(googleProvider.getCurrentUser.registeredViaGoogle
                        .toString());
                    debugPrint(googleProvider.getCurrentUser.accountCreated
                        .toString());
                  },
                  child: const Icon(Icons.info))
            ],
          )
        ],
      ),
    );
  }
}
