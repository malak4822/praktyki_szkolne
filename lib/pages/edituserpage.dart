import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prakty/main.dart';
import 'package:prakty/providers/googlesign.dart';
import 'package:provider/provider.dart';
import '../providers/edituser.dart';
import '../services/database.dart';
import '../widgets/edituserpopup.dart';

class EditUserPage extends StatelessWidget {
  EditUserPage({super.key});

  int essa = 0;

  @override
  Widget build(BuildContext context) {
    var editUserProvider = Provider.of<EditUser>(context);
    var googleProvider = Provider.of<GoogleSignInProvider>(context);
    return Scaffold(
        body: Stack(children: [
      ListView(children: [
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
                  child: CircleAvatar(
                      radius: 85,
                      backgroundColor: Colors.white,
                      child: Container(
                          height: 160,
                          width: 160,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(colors: gradient),
                          ),
                          child: Stack(children: [
                            ClipOval(
                              child: FadeInImage(
                                height: 160,
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
                            ),
                            if (googleProvider
                                    .getCurrentUser.registeredViaGoogle ==
                                false)
                              ClipOval(child: blackBox(0, editUserProvider))
                          ]))))
            ])),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
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
                  child: Stack(children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 10),
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
                    ),
                    blackBox(1, editUserProvider)
                  ])),
              const SizedBox(height: 6),
              SizedBox(
                  height: 140,
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: 4,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => skillEditBox(
                          'successTxt', 2, context, editUserProvider)))
            ])),
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
                  debugPrint(
                      googleProvider.getCurrentUser.accountCreated.toString());
                },
                child: const Icon(Icons.info))
          ],
        )
      ]),
      Visibility(
          visible: editUserProvider.isEditingSeen,
          child: EditPopUpParent(
            openWidgetIndex: essa,
          )),
    ]));
  }

  Widget blackBox(int index, editUserProvider) => Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8), color: Colors.black54),
      width: double.infinity,
      height: double.infinity,
      child: IconButton(
        iconSize: 34,
        onPressed: () {
          essa = index;
          editUserProvider.toogleEditingPopUp();
        },
        icon: const Icon(Icons.mode_edit_outlined),
        color: Colors.white,
      ));

  Widget skillEditBox(successTxt, skillLevel, context, editUserProvider) =>
      Container(
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
          child: Stack(children: [
            Column(mainAxisAlignment: MainAxisAlignment.center, children: [
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
            ]),
            blackBox(2, editUserProvider),
          ]));
}
