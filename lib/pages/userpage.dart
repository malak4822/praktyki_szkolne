import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prakty/providers/googlesign.dart';
import 'package:prakty/services/database.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class FriendsPage extends StatelessWidget {
  const FriendsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var googleProvider = Provider.of<GoogleSignInProvider>(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: () {},
          elevation: 0,
          highlightElevation: 0,
          backgroundColor: const Color.fromARGB(255, 0, 162, 226),
          child: const Icon(
            Icons.settings,
            size: 40,
          )),
      body: ListView(
        children: [
          SizedBox(
              height: 180,
              child: Stack(children: [
                const Align(
                    alignment: Alignment(0.9, -0.8),
                    child: Image(
                        image: AssetImage('images/whitemenuicon.png'),
                        height: 30)),
                Align(
                    alignment: const Alignment(0, 0.5),
                    child: Container(
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(colors: gradient)),
                        child: CircleAvatar(
                            radius: 74,
                            backgroundColor: Colors.white,
                            child: ClipOval(
                              child: FadeInImage(
                                height: 140,
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
                      color: Colors.green,
                      fontSize: 24,
                      fontWeight: FontWeight.w900),
                ),
                Text(googleProvider.getCurrentUser.description,
                    maxLines: 4,
                    style: GoogleFonts.overpass(
                        fontSize: 17, fontWeight: FontWeight.w200)),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 0, 162, 226)),
                    onPressed: () {
                      Provider.of<GoogleSignInProvider>(context, listen: false)
                          .logout();
                    },
                    child: const Icon(Icons.exit_to_app)),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 0, 162, 226)),
                    onPressed: () async {
                      googleProvider.getCurrentUser;

                      await MyDb().getUserInfo(googleProvider.getCurrentUser);

                      debugPrint(googleProvider.getCurrentUser.username);
                      debugPrint(googleProvider.getCurrentUser.email);
                      debugPrint(googleProvider.getCurrentUser.profilePicture);
                      debugPrint(googleProvider.getCurrentUser.userId);
                      debugPrint(googleProvider
                          .getCurrentUser.registeredViaGoogle
                          .toString());
                      debugPrint(googleProvider.getCurrentUser.accountCreated
                          .toString());
                    },
                    child: const Icon(Icons.info))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
