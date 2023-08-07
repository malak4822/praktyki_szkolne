import 'package:flutter/material.dart';
import 'package:prakty/main.dart';
import 'package:prakty/providers/functions.dart';
import 'package:prakty/pages/userpage.dart';
import 'package:provider/provider.dart';

class LoggedParentWidget extends StatelessWidget {
  const LoggedParentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      const Center(child: Icon(Icons.abc)),
      const Center(child: Icon(Icons.abc)),
      const FriendsPage(),
    ];
    return ChangeNotifierProvider(
      create: (context) => Functions(),
      builder: (context, widget) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Jebać Babilon', style: myPrimaryFont),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: gradient, stops: [0.0, 0.8]),
            ),
          ),
        ),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: gradient, stops: [0.0, 0.8]),
          ),
          child: BottomNavigationBar(
            currentIndex: Provider.of<Functions>(context).currentIndex,
            onTap: (newIndex) {
              Provider.of<Functions>(context, listen: false)
                  .changePage(newIndex);
            },
            showUnselectedLabels: false,
            showSelectedLabels: false,
            backgroundColor: Colors.transparent,
            fixedColor: Colors.white,
            elevation: 0,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.messenger_outline_rounded), label: ""),
              BottomNavigationBarItem(icon: Icon(Icons.business), label: ""),
              BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
            ],
          ),
        ),
        body: pages[Provider.of<Functions>(context).currentIndex],
      ),
    );
  }
}
