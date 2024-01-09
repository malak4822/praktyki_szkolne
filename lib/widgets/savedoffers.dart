import 'package:flutter/material.dart';
import 'package:prakty/constants.dart';
import 'package:prakty/models/advertisements_model.dart';
import 'package:prakty/models/user_model.dart';
import 'package:prakty/providers/googlesign.dart';
import 'package:prakty/services/database.dart';
import 'package:prakty/widgets/loadingscreen.dart';
import 'package:prakty/widgets/topbuttons.dart';
import 'package:prakty/widgets/noticecard.dart';
import 'package:provider/provider.dart';

class SavedOffers extends StatelessWidget {
  const SavedOffers(
      {super.key,
      required this.isAccountTypeUser,
      required this.accountFavAds});

  final bool isAccountTypeUser;
  final List<String> accountFavAds;

  @override
  Widget build(BuildContext context) {
    List<String> favList =
        Provider.of<GoogleSignInProvider>(context).getCurrentUser.likedOffers;
    return Scaffold(
        body: SafeArea(
            child: Stack(children: [
      Container(
          width: double.maxFinite,
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            boxShadow: myBoxShadow,
            gradient: const LinearGradient(colors: gradient),
            borderRadius: BorderRadius.circular(16),
          ),
          child: FutureBuilder(
              future: isAccountTypeUser
                  ? MyDb().downloadFavJobNotices(favList)
                  : MyDb().downloadFavUsersNotices(favList),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingWidget();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                        const SizedBox(height: 12),
                        const Icon(Icons.search_off_rounded,
                            color: Colors.white, size: 82),
                        Text('Nie Masz Żadnych Ulubionych Ogłoszeń',
                            style: fontSize20, textAlign: TextAlign.center)
                      ]));
                } else {
                  List<MyUser> userList = [];
                  List<JobAdModel> jobList = [];
                  if (isAccountTypeUser) {
                    jobList = List.from(snapshot.data!);
                  } else {
                    userList = List.from(snapshot.data!);
                  }
                  return ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: favList.length,
                      itemBuilder: (context, index) {
                        return NoticeCard(
                            isUserNoticePage: isAccountTypeUser ? false : true,
                            info: isAccountTypeUser
                                ? jobList[index]
                                : userList[index]);
                      });
                }
              })),
      backButton(context),
    ])));
  }
}
