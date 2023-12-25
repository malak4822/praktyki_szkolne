import 'package:flutter/material.dart';
import 'package:prakty/constants.dart';
import 'package:prakty/providers/edituser.dart';
import 'package:prakty/widgets/backbutton.dart';
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
    List<String> favList = Provider.of<EditUser>(context).favList;
    return Scaffold(
        body: SafeArea(
            child: Stack(children: [
      Container(
          width: double.maxFinite,
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            boxShadow: myBoxShadow,
            gradient: const LinearGradient(colors: gradient),
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListView.builder(
              itemCount: favList.length,
              itemBuilder: (context, index) => NoticeCard(
                    noticeCardName: isAccountTypeUser ? 'UserCard' : 'JobCard',
                    info: accountFavAds,
                  ))),
      backButton(context),
    ])));
  }
}
