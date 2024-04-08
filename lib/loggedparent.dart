import 'dart:async';

import 'package:flutter/material.dart';
import 'package:prakty/constants.dart';
import 'package:prakty/models/user_model.dart';
import 'package:prakty/view/notices.dart';
import 'package:prakty/view/userpage.dart';
import 'package:prakty/providers/googlesign.dart';
import 'package:prakty/widgets/loadingscreen.dart';
import 'package:provider/provider.dart';

class LoggedParentWidget extends StatefulWidget {
  const LoggedParentWidget({super.key});

  @override
  State<LoggedParentWidget> createState() => _LoggedParentWidgetState();
}

class _LoggedParentWidgetState extends State<LoggedParentWidget> {
  List<MyUser>? usersSortedByLocation;

  bool wasSortedByLocation = false;

  int _currentIndex = 1;
  Completer<void> setUserOnStartVal = Completer<void>();

  @override
  void initState() {
    setUpUser();
    super.initState();
  }

  void setUpUser() async {
    await Provider.of<GoogleSignInProvider>(context, listen: false)
        .setUserOnStart(context)
        .then((value) => setUserOnStartVal.complete());
  }

  void changePage(int newIndex) {
    setState(() {
      _currentIndex = newIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    wasSortedByLocation =
        Provider.of<GoogleSignInProvider>(context, listen: false)
            .wasSortedByLocation;
    List<Widget> pages = [
      NoticesPage(
        isUserNoticePage: true,
        currentUserPlaceId:
            Provider.of<GoogleSignInProvider>(context, listen: false)
                .getCurrentUser
                .placeId,
        wasSortedByLocation: wasSortedByLocation,
        callBack: (info) {
          Provider.of<GoogleSignInProvider>(context, listen: false)
              .changeSortedLoc = true;
          usersSortedByLocation = List.from(info);
        },
        usersSortedByLocation: usersSortedByLocation,
      ),
      NoticesPage(
        isAccountTypeUser:
            Provider.of<GoogleSignInProvider>(context, listen: false)
                .getCurrentUser
                .isAccountTypeUser,
        isUserNoticePage: false,
        currentUserPlaceId:
            Provider.of<GoogleSignInProvider>(context, listen: false)
                .getCurrentUser
                .placeId,
        wasSortedByLocation: false,
        callBack: () {},
        usersSortedByLocation: null,
      ),
      FutureBuilder(
          future: setUserOnStartVal.future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingWidget();
            } else if (snapshot.connectionState == ConnectionState.done) {
              return UserPage(
                  shownUser:
                      Provider.of<GoogleSignInProvider>(context, listen: false)
                          .getCurrentUser,
                  isOwnProfile: true);
            } else {
              return Center(
                  child: Text('Wystąpił Błąd, Spróbuj Ponownie Później',
                      style: fontSize20));
            }
          }),
    ];
    return Scaffold(
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.elliptical(300, 20)),
          gradient: LinearGradient(colors: gradient, stops: [0.0, 0.8]),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (newIndex) => changePage(newIndex),
          showUnselectedLabels: false,
          showSelectedLabels: false,
          backgroundColor: Colors.transparent,
          fixedColor: Colors.white,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.people), label: ""),
            BottomNavigationBarItem(icon: Icon(Icons.business), label: ""),
            BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          ],
        ),
      ),
      body: pages[_currentIndex],
    );
  }
}
