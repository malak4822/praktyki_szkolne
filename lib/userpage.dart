import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prakty/providers/googlesign.dart';
import 'package:prakty/services/database.dart';
import 'package:provider/provider.dart';

class FriendsPage extends StatelessWidget {
  const FriendsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var googleProvider = Provider.of<GoogleSignInProvider>(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: () async {},
          elevation: 0,
          highlightElevation: 0,
          backgroundColor: Colors.white,
          child: const Icon(
            Icons.settings,
            size: 40,
          )),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 72,
                  backgroundColor: Colors.black,
                  child: CircleAvatar(
                    radius: 70,
                    backgroundColor: Colors.white12,
                    backgroundImage: NetworkImage(
                     googleProvider.getCurrentUser.registeredViaGoogle ? googleProvider.getCurrentUser.profilePicture : 'https://assets.codepen.io/1480814/av+1.png'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        googleProvider.getCurrentUser.username,
                        softWrap: true,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.overpass(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.w900),
                      ),
                      Text(googleProvider.getCurrentUser.description,
                          maxLines: 4,
                          style: GoogleFonts.overpass(
                              fontSize: 17, fontWeight: FontWeight.w200)),
                      ElevatedButton(
                          onPressed: () {
                            Provider.of<GoogleSignInProvider>(context,
                                    listen: false)
                                .logout();
                          },
                          child: const Icon(Icons.exit_to_app)),
                      ElevatedButton(
                          onPressed: () async {
                            googleProvider.getCurrentUser;

                            await MyDb()
                                .getUserInfo(googleProvider.getCurrentUser);

                            debugPrint(googleProvider.getCurrentUser.username);
                            debugPrint(googleProvider.getCurrentUser.email);
                            debugPrint(
                                googleProvider.getCurrentUser.profilePicture);
                            debugPrint(googleProvider.getCurrentUser.userId);
                            debugPrint(googleProvider
                                .getCurrentUser.registeredViaGoogle
                                .toString());
                            debugPrint(googleProvider
                                .getCurrentUser.accountCreated
                                .toString());
                          },
                          child: const Icon(Icons.info))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
