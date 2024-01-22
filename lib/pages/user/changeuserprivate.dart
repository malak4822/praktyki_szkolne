import 'package:flutter/material.dart';
import 'package:prakty/constants.dart';
import 'package:prakty/models/user_model.dart';
import 'package:prakty/providers/editjobprov.dart';
import 'package:prakty/providers/googlesign.dart';
import 'package:prakty/services/database.dart';
import 'package:prakty/pages/jobs/myoffers.dart';
import 'package:prakty/widgets/savedoffers.dart';
import 'package:provider/provider.dart';

class EditPrivUserInfo extends StatelessWidget {
  const EditPrivUserInfo(
      {super.key, required this.currentUser, required this.emailCont});
  final TextEditingController emailCont;
  final MyUser currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Align(
          alignment: Alignment.centerRight,
          child: Container(
            width: MediaQuery.of(context).size.width - 40,
            height: MediaQuery.of(context).size.height - 160,
            decoration: const BoxDecoration(
                gradient: LinearGradient(colors: gradient),
                boxShadow: myBoxShadow,
                borderRadius:
                    BorderRadius.horizontal(left: Radius.circular(400))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                    padding: const EdgeInsets.all(26),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (currentUser.isAccountTypeUser)
                          CheckboxListTile(
                              checkboxShape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              activeColor: Colors.white,
                              side: MaterialStateBorderSide.resolveWith(
                                  (states) => const BorderSide(
                                      width: 2, color: Colors.white)),
                              title: Text(
                                  "Ogłaszaj Mnie Jako Szukającego Pracy",
                                  style: fontSize16),
                              value: Provider.of<GoogleSignInProvider>(context)
                                  .getCurrentUser
                                  .jobVacancy,
                              dense: true,
                              controlAffinity: ListTileControlAffinity.trailing,
                              onChanged: (newValue) async {
                                try {
                                  var hasVacancy = await MyDb()
                                      .addUserJobNotice(
                                          currentUser.userId, newValue);
                                  if (hasVacancy == false) {
                                    if (!context.mounted) return;
                                    Provider.of<GoogleSignInProvider>(context,
                                            listen: false)
                                        .userSearchingToogle(newValue);
                                  }
                                } catch (e) {
                                  debugPrint(e.toString());
                                }
                              }),
                      ],
                    )),
                if (!currentUser.isAccountTypeUser)
                  button(Icons.ad_units, 'Moje Ogłoszenia', () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChangeNotifierProvider(
                                create: (value) => EditJobProvider(),
                                builder: (context, child) => MyOffers(
                                      isAccountTypeUser:
                                          currentUser.isAccountTypeUser,
                                      userId: currentUser.userId,
                                    ))));
                  }),
                const SizedBox(height: 6),
                button(Icons.favorite_border, 'Ulubione', () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SavedOffers(
                                isAccountTypeUser:
                                    currentUser.isAccountTypeUser,
                                accountFavAds: currentUser.likedOffers,
                              )));
                }),
                const SizedBox(height: 6),
                button(Icons.logout_outlined, 'Wyloguj Się', () {
                  Navigator.pop(context);
                  Provider.of<GoogleSignInProvider>(context, listen: false)
                      .logout();
                })
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget button(IconData icon, String text, Function function) => Container(
        height: 60,
        color: Colors.white24,
        width: double.maxFinite,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => function(),
            splashFactory: InkRipple.splashFactory,
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(icon, color: Colors.white),
              const SizedBox(width: 10),
              Text(text, style: fontSize16)
            ]),
          ),
        ),
      );
}
