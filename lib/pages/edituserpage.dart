import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prakty/main.dart';
import 'package:prakty/pages/userpage.dart';
import 'package:prakty/providers/googlesign.dart';
import 'package:provider/provider.dart';

import '../services/database.dart';

class EditUserPage extends StatelessWidget {
  const EditUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    var googleProvider = Provider.of<GoogleSignInProvider>(context);
    return Scaffold(
        body: ListView(children: [
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
                        radius: 85,
                        backgroundColor: Colors.white,
                        child: ClipOval(
                          child: FadeInImage(
                            height: 160,
                            fit: BoxFit.contain,
                            fadeInDuration: const Duration(milliseconds: 500),
                            image: NetworkImage(
                              googleProvider.getCurrentUser.registeredViaGoogle
                                  ? googleProvider.getCurrentUser.profilePicture
                                  : 'https://assets.codepen.io/1480814/av+1.png',
                            ),
                            placeholder: const NetworkImage(
                                'https://assets.codepen.io/1480814/av+1.png'),
                          ),
                        )))),
          ])),
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(children: [
            Container(
                decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: gradient),
                    borderRadius: BorderRadius.circular(8)),
                height: 150,
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: ListView(children: [
                    Text(
                      googleProvider.getCurrentUser.username,
                      softWrap: true,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.overpass(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w900),
                    ),
                    Text(googleProvider.getCurrentUser.description,
                        maxLines: 4,
                        style: GoogleFonts.overpass(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                  ]),
                )),
            const SizedBox(height: 15),
            SizedBox(
                height: 140,
                child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: 4,
                    scrollDirection: Axis.horizontal,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 16),
                    itemBuilder: (context, index) =>
                        skillBox('successTxt', 2))),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 0, 162, 226)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.home)),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 0, 162, 226)),
                    onPressed: () {
                      Navigator.pop(context);
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
                      debugPrint(googleProvider.getCurrentUser.age.toString());
                      debugPrint(googleProvider.getCurrentUser.isNormalUser
                          .toString());
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
            )
          ])),
    ]));
  }
}
