import 'package:flutter/material.dart';
import 'package:prakty/constants.dart';
import 'package:prakty/models/user_model.dart';
import 'package:prakty/providers/googlesign.dart';
import 'package:prakty/services/database.dart';
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
            child: Stack(
              children: [
                Padding(
                    padding: const EdgeInsets.all(26),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CheckboxListTile(
                            checkboxShape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            activeColor: Colors.white,
                            side: MaterialStateBorderSide.resolveWith(
                                (states) => const BorderSide(
                                    width: 2, color: Colors.white)),
                            title: Text("Ogłaszaj Mnie Jako Szukającego Pracy",
                                style: fontSize16),
                            value: Provider.of<GoogleSignInProvider>(context)
                                .getCurrentUser
                                .jobVacancy,
                            dense: true,
                            controlAffinity: ListTileControlAffinity.trailing,
                            onChanged: (newValue) async {
                              try {
                                var hasVacancy = await MyDb().addUserJobNotice(
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
                Align(
                  alignment: Alignment.bottomCenter,
                  child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        Provider.of<GoogleSignInProvider>(context,
                                listen: false)
                            .logout();
                      },
                      child: Container(
                          width: double.infinity,
                          height: 80,
                          alignment: Alignment.centerRight,
                          color: Colors.white24,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text('Wyloguj Się ', style: fontSize16),
                              const Icon(Icons.logout_rounded,
                                  color: Colors.white, size: 20),
                              const SizedBox(width: 4),
                            ],
                          ))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
