import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prakty/constants.dart';
import 'package:prakty/models/user_model.dart';
import 'package:prakty/services/database.dart';
import 'package:prakty/view/userpage.dart';

class UsersNoticesPage extends StatelessWidget {
  const UsersNoticesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: FutureBuilder(
                future: MyDb().downloadUsersStates(),
                builder: (context, AsyncSnapshot<List> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.location_searching_outlined,
                                    color: gradient[0], size: 52),
                                const SizedBox(height: 30),
                                Text(
                                    'Narazie Niestety Nie Ma Ogłoszeń W Twojej Okolicy',
                                    style: GoogleFonts.overpass(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w900,
                                        color: gradient[0]),
                                    textAlign: TextAlign.center)
                              ])),
                    );
                  } else {
                    final myUsersList = snapshot.data;
                    return Container(
                        padding: const EdgeInsets.only(bottom: 10, top: 4),
                        child: ListView.builder(
                            clipBehavior: Clip.none,
                            itemCount: myUsersList!.length,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              return UserNotice(userInfo: myUsersList[index]);
                            }));
                  }
                })));
  }
}

class UserNotice extends StatelessWidget {
  const UserNotice({super.key, required this.userInfo});

  final Map userInfo;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          print(userInfo['username']);

          // Navigator.pushNamed(context, '/userPage', arguments: userInfo);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      UserPage(isOwnProfile: false, shownUser: userInfo)));
        },
        child: Container(
            decoration: BoxDecoration(
                boxShadow: myBoxShadow,
                gradient: const LinearGradient(colors: gradient),
                borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: SizedBox(
                height: 120,
                child: Row(children: [
                  Expanded(
                      flex: 3,
                      child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  userInfo['username'],
                                  style: fontSize20,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                                Text(userInfo['description'],
                                    maxLines: 3,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.overpass(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.location_city,
                                        size: 18, color: Colors.white),
                                    Expanded(
                                        child: Text(userInfo['location'],
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: GoogleFonts.overpass(
                                                fontSize: 12,
                                                color: Colors.white))),
                                  ],
                                )
                              ]))),
                  CircleAvatar(
                      radius: 52.5,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 50,
                        foregroundImage: NetworkImage(userInfo['profilePicture']
                                .isNotEmpty
                            ? userInfo['profilePicture']
                            : 'https://firebasestorage.googleapis.com/v0/b/praktyki-szkolne.appspot.com/o/my_files%2Fman_praktyki.png?alt=media&token=dec782e2-1e50-4066-b0b6-0dc8019463d8&_gl=1*4wskaw*_ga*MTg3NTU1MzM0MC4xNjk4MzAyMTM5*_ga_CW55HF8NVT*MTY5OTI4NjY4OC42LjEuMTY5OTI4NjcwMS40Ny4wLjA'),
                      )),
                  const SizedBox(width: 10),
                ]))));
  }
}
