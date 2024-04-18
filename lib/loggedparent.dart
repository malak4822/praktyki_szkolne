import 'dart:async';

import 'package:flutter/material.dart';
import 'package:prakty/constants.dart';
import 'package:prakty/models/advertisements_model.dart';
import 'package:prakty/models/user_model.dart';
import 'package:prakty/services/database.dart';
import 'package:prakty/view/notices.dart';
import 'package:prakty/view/userpage.dart';
import 'package:prakty/providers/googlesign.dart';
import 'package:prakty/widgets/loadingscreen.dart';
import 'package:provider/provider.dart';

class LoggedParentWidget extends StatefulWidget {
  const LoggedParentWidget({super.key});

  @override
  State<LoggedParentWidget> createState() => LoggedParentWidgetState();
}

class LoggedParentWidgetState extends State<LoggedParentWidget> {
  Future<List<MyUser>>? usersData;
  Future<List<JobAdModel>>? jobsData;

  List<MyUser>? usersSortedByLocation;
  List<JobAdModel>? jobsSortedByLocation;

  bool wereUsersSortedByLocation = false;
  bool wereJobsSortedByLocation = false;

  late int _currentIndex;
  late Future<void> setUserOnStartVal;

  Future<void> _handleRefresh() async {
    downloadList();
    await Future.delayed(Duration(seconds: 1));
    setState(() {});
  }

  @override
  void initState() {
    downloadList();
    setUserOnStartVal =
        Provider.of<GoogleSignInProvider>(context, listen: false)
            .setUserOnStart(context);

    super.initState();
  }

  void downloadList() {
    usersData = MyDb().downloadUsersStates();
    jobsData = MyDb().downloadJobAds();
  }

  void changePage(int newIndex) {
    Provider.of<GoogleSignInProvider>(context, listen: false).setPageIndex =
        newIndex;
  }

  @override
  Widget build(BuildContext context) {
    _currentIndex = Provider.of<GoogleSignInProvider>(context).pageIndex;

    List<Widget> pages = [
      NoticesPage(
        isUserNoticePage: true,
        currentUserPlaceId:
            Provider.of<GoogleSignInProvider>(context, listen: false)
                .getCurrentUser
                .placeId,
        wasSortedByLocation: wereUsersSortedByLocation,
        callBack: (info, String actionName) {
          switch (actionName) {
            case ('saveUsersLocList'):
              // SAVING SORTED USERS DATA
              wereUsersSortedByLocation = true;
              usersSortedByLocation = List.from(info);
              break;

            case ('setStateOnUserPage'):
              // USER SETTINGS CHANGED, DOWNLOADING LIST AGAIN AND SORTING
              wereUsersSortedByLocation = false;
              usersData = MyDb().downloadUsersStates();
              setState(() {});
              break;
          }
        },
        dataSortedByLocation: usersSortedByLocation,
        noticesData: usersData,
      ),
      FutureBuilder(
          future: setUserOnStartVal,
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
        wasSortedByLocation: wereJobsSortedByLocation,
        callBack: (info, String actionName) {
          switch (actionName) {
            case ('saveJobsLocList'):
              // SAVING SORTED JOBS DATA
              wereJobsSortedByLocation = true;
              jobsSortedByLocation = List.from(info);
              break;

            case ('setStateOnJobsPage'):
              // USER SETTINGS CHANGED, DOWNLOADING LIST AGAIN AND SORTING
              wereJobsSortedByLocation = false;
              jobsData = MyDb().downloadJobAds();
              setState(() {});
              break;
          }
        },
        dataSortedByLocation: jobsSortedByLocation,
        noticesData: jobsData,
      ),
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
            BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
            BottomNavigationBarItem(icon: Icon(Icons.business), label: ""),
          ],
        ),
      ),
      body: RefreshIndicator(
          color: Color.fromARGB(255, 21, 187, 242),
          strokeWidth: 4,
          edgeOffset: 22,
          onRefresh: _handleRefresh,
          child: pages[_currentIndex]),
    );
  }
}
