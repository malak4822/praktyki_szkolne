import 'package:flutter/material.dart';
import 'package:prakty/constants.dart';
import 'package:prakty/models/advertisements_model.dart';
import 'package:prakty/providers/googlesign.dart';
import 'package:prakty/services/database.dart';
import 'package:prakty/widgets/loadingscreen.dart';
import 'package:prakty/widgets/topbuttons.dart';
import 'package:prakty/widgets/noticecard.dart';
import 'package:provider/provider.dart';

class MyOffers extends StatelessWidget {
  const MyOffers(
      {super.key, required this.isAccountTypeUser, required this.userId});

  final bool isAccountTypeUser;
  final String userId;

  @override
  Widget build(BuildContext context) {
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
              future: MyDb().downloadMyOffers(userId),
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
                        Text('Nie Masz Jeszcze Swoich Ogłoszeń',
                            style: fontSize20, textAlign: TextAlign.center)
                      ]));
                } else {
                  List<JobAdModel> jobList = [];
                  jobList = List.from(snapshot.data!);
                  Provider.of<GoogleSignInProvider>(context, listen: false)
                      .setMyOffersList = jobList;

                  return ListView.separated(
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      padding: const EdgeInsets.all(12),
                      itemCount: jobList.length,
                      itemBuilder: (context, index) {
                        return NoticeCard(
                            noticeType: 'jobNotice', info: jobList[index]);
                      });
                }
              })),
      backButton(context),
    ])));
  }
}
