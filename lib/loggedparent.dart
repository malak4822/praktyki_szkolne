import 'package:flutter/material.dart';
import 'package:prakty/constants.dart';
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
  int _currentIndex = 1;

  void changePage(int newIndex) {
    setState(() {
      _currentIndex = newIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      const NoticesPage(isUserNoticePage: true),
      NoticesPage(
        isAccountTypeUser:
            Provider.of<GoogleSignInProvider>(context, listen: false)
                .getCurrentUser
                .isAccountTypeUser,
        isUserNoticePage: false,
      ),
      FutureBuilder(
          future: Provider.of<GoogleSignInProvider>(context, listen: false)
              .setUserOnStart(context),
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
                  child: Text(
                      'Wystąpił Nie Typowy Błąd, Spróbuj Ponownie Później',
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
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.business),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "",
            ),
          ],
        ),
      ),
      body: pages[_currentIndex],
    );
  }
}
