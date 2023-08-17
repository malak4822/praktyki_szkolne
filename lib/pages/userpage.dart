import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prakty/providers/edituser.dart';
import 'package:prakty/providers/googlesign.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../widgets/skillboxes.dart';

class UserPage extends StatelessWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var googleProvider = Provider.of<GoogleSignInProvider>(context);
    var editUserProvider = Provider.of<EditUser>(context);
    var editUserFunction = Provider.of<EditUser>(context, listen: false);
    return Scaffold(
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              editUserFunction.checkEmptiness(
                  googleProvider.getCurrentUser.username.isEmpty,
                  googleProvider.getCurrentUser.description.isEmpty);

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
                    child: ClipOval(
                        child: FadeInImage(
                      fit: BoxFit.contain,
                      height: 160,
                      fadeInDuration: const Duration(milliseconds: 500),
                      image: NetworkImage(
                        googleProvider.getCurrentUser.registeredViaGoogle
                            ? googleProvider.getCurrentUser.profilePicture
                            : 'https://assets.codepen.io/1480814/av+1.png',
                      ),
                      placeholder: const NetworkImage(
                          'https://assets.codepen.io/1480814/av+1.png'),
                    )),
                  ),
                ))
              ])),
          SizedBox(
              height: 300,
              child: Column(children: [
                Expanded(
                    flex: 11,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 25),
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
                      child: ListView(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          children: [
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
                                style: GoogleFonts.overpass(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold)),
                          ]),
                    )),
                Visibility(
                    visible: editUserProvider.skillBoxes.isNotEmpty,
                    child: Expanded(
                        flex: 9,
                        child: Padding(
                            padding: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width / 13,
                                right: MediaQuery.of(context).size.width / 13,
                                top: 6),
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: editUserProvider.skillBoxes.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) => skillBox(
                                    editUserProvider
                                        .skillBoxes[index].keys.single,
                                    editUserProvider
                                        .skillBoxes[index].values.single,
                                    context,
                                    false))))),
              ])),
        ]));
  }
}
