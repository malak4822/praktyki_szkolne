import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prakty/providers/googlesign.dart';
import 'package:provider/provider.dart';
import '../main.dart';

class FriendsPage extends StatelessWidget {
  const FriendsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var googleProvider = Provider.of<GoogleSignInProvider>(context);

    return Scaffold(
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, '/editUser');
            },
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
                            radius: 85,
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
                Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: gradient),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black54,
                          spreadRadius: 0.3,
                          blurRadius: 5,
                        ),
                      ],
                    ),
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
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: 4,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) =>
                            skillBox('successTxt', 2, context)))
              ])),
        ]));
  }
}

Widget skillBox(successTxt, skillLevel, context) => Container(
      height: 120,
      margin: const EdgeInsets.all(6),
      width: MediaQuery.of(context).size.width / 4,
      decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
              color: Colors.black54,
              spreadRadius: 0.3,
              blurRadius: 5,
            ),
          ],
          gradient: const LinearGradient(colors: gradient),
          borderRadius: BorderRadius.circular(8)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.star, color: Colors.white, size: 38),
          const SizedBox(height: 10),
          Text(successTxt, style: fontSize16),
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
