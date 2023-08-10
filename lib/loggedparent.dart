import 'package:flutter/material.dart';
import 'package:prakty/main.dart';
import 'package:prakty/pages/userpage.dart';

class LoggedParentWidget extends StatefulWidget {
  const LoggedParentWidget({super.key});

  @override
  State<LoggedParentWidget> createState() => _LoggedParentWidgetState();
}

class _LoggedParentWidgetState extends State<LoggedParentWidget> {
  int _currentIndex = 2;

  void changePage(int newIndex) {
    setState(() {
      _currentIndex = newIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      const Center(child: Icon(Icons.abc)),
      const Center(child: Icon(Icons.abc)),
      const FriendsPage(),
    ];
    return Scaffold(
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: gradient,
              stops: [0.0, 0.8],
            ),
            borderRadius: BorderRadius.vertical(
              top: Radius.elliptical(300, 20),
            )),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (newIndex) {
            changePage(newIndex);
          },
          showUnselectedLabels: false,
          showSelectedLabels: false,
          backgroundColor: Colors.transparent,
          fixedColor: Colors.white,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.messenger_outline_rounded), label: ""),
            BottomNavigationBarItem(icon: Icon(Icons.business), label: ""),
            BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          ],
        ),
      ),
      body: pages[_currentIndex],
    );
  }
}
