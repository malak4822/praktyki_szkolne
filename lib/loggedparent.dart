import 'package:flutter/material.dart';
import 'package:prakty/providers/functions.dart';
import 'package:prakty/userpage.dart';
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
              bottomNavigationBar: BottomNavigationBar(
                  items: const [
                    BottomNavigationBarItem(icon: Icon(Icons.abc), label: ''),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.deblur), label: ''),
                    BottomNavigationBarItem(icon: Icon(Icons.man), label: ''),
                  ],
                  currentIndex: Provider.of<Functions>(context).currentIndex,
                  onTap: (newIndex) {
                    Provider.of<Functions>(context, listen: false)
                        .changePage(newIndex);
                  }),
              body: pages[Provider.of<Functions>(context).currentIndex],
            ));
  }
}
