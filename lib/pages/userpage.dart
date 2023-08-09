import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prakty/providers/googlesign.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import 'edituserpage.dart';

class FriendsPage extends StatelessWidget {
  const FriendsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var googleProvider = Provider.of<GoogleSignInProvider>(context);

    return Scaffold(
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const EditUserPage()));
            },
            elevation: 0,
            highlightElevation: 0,
            backgroundColor: const Color.fromARGB(255, 0, 162, 226),
            child: const Icon(
              Icons.settings,
              size: 40,
            )),
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
                                placeholder: const NetworkImage(
                                    'https://assets.codepen.io/1480814/av+1.png'),
                              ),
                            )))),
              ])),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(children: [
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
                const SizedBox(height: 20),
                SizedBox(
                    height: 140,
                    child: ListView.separated(
                        itemCount: 3,
                        scrollDirection: Axis.horizontal,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 16 ),
                        itemBuilder: (context, index) =>
                            skillBox('successTxt', 2)))
              ])),
        ]));
  }
}

Widget skillBox(successTxt, skillLevel) => Container(
      height: 120,
      width: 100,
      decoration: BoxDecoration(
          gradient: const LinearGradient(colors: gradient),
          borderRadius: BorderRadius.circular(8)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.star, color: Colors.white, size: 38),
          const SizedBox(height: 10),
          Text(successTxt,
              style: GoogleFonts.overpass(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 18)),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                  skillLevel,
                  (index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 1),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        width: 8,
                        height: 8,
                      ))))
        ],
      ),
    );
