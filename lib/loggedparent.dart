import 'package:flutter/material.dart';
import 'package:prakty/main.dart';
import 'package:prakty/pages/jobs/jobs.dart';
import 'package:prakty/view/userpage.dart';
import 'package:prakty/providers/googlesign.dart';
import 'package:provider/provider.dart';

class LoggedParentWidget extends StatefulWidget {
  const LoggedParentWidget({super.key});

  @override
  State<LoggedParentWidget> createState() => _LoggedParentWidgetState();
}

class _LoggedParentWidgetState extends State<LoggedParentWidget> {
  @override
  void initState() {
    Provider.of<GoogleSignInProvider>(context, listen: false)
        .setUserOnStart(context);
    super.initState();
  }

  int _currentIndex = 1;

  void changePage(int newIndex) {
    setState(() {
      _currentIndex = newIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      const Center(child: Icon(Icons.abc)),
      const JobNoticesPage(),
      const UserPage(),
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
              icon: Icon(Icons.messenger_outline_rounded),
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
