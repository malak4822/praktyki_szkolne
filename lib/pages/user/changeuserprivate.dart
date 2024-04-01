import 'package:flutter/material.dart';
import 'package:prakty/constants.dart';
import 'package:prakty/models/user_model.dart';
import 'package:prakty/providers/edituser.dart';
import 'package:prakty/providers/googlesign.dart';
import 'package:prakty/services/database.dart';
import 'package:prakty/pages/jobs/myoffers.dart';
import 'package:prakty/widgets/savedoffers.dart';
import 'package:provider/provider.dart';

class EditPrivUserInfo extends StatefulWidget {
  const EditPrivUserInfo(
      {super.key, required this.currentUser, required this.ifNoInternetGoBack});
  final MyUser currentUser;
  final Function ifNoInternetGoBack;

  @override
  State<EditPrivUserInfo> createState() => _EditPrivUserInfoState();
}

class _EditPrivUserInfoState extends State<EditPrivUserInfo> {
  late bool isEagerToWork;

  @override
  void initState() {
    super.initState();
    isEagerToWork = widget.currentUser.jobVacancy;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Stack(
      children: [
        Container(
          alignment: Alignment.topLeft,
          width: 112,
          height: 112,
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
              Color.fromARGB(255, 0, 82, 156),
              Color.fromARGB(255, 1, 192, 209),
            ]),
            boxShadow: [
              BoxShadow(
                  color: Colors.black38,
                  spreadRadius: 0.2,
                  blurRadius: 8,
                  offset: Offset(0, 6))
            ],
            borderRadius: BorderRadius.only(bottomRight: Radius.circular(112)),
          ),
          child: IconButton(
            alignment: Alignment.topLeft,
            // padding: const EdgeInsets.all(22),
            iconSize: 28,
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () => widget.ifNoInternetGoBack(),
          ),
        ),
        // backButton(context),
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            clipBehavior: Clip.hardEdge,
            width: MediaQuery.of(context).size.width - 40,
            height: MediaQuery.of(context).size.height - 160,
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: gradient),
              boxShadow: myBoxShadow,
              borderRadius: BorderRadius.horizontal(left: Radius.circular(400)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.currentUser.isAccountTypeUser)
                  button(Icons.work,
                      isEagerToWork ? 'Nie Szukam Praktyk' : 'Szukam Praktyk',
                      () async {
                    if (!await Provider.of<EditUser>(context, listen: false)
                        .checkInternetConnectivity()) {
                      widget.ifNoInternetGoBack();
                    }
                    late bool tempEagerValue = isEagerToWork;

                    tempEagerValue = !isEagerToWork;

                    bool? uploadResult = await MyDb().addUserJobNotice(
                        widget.currentUser.userId, tempEagerValue);

                    if (uploadResult != null) {
                      if (context.mounted) {
                        Provider.of<GoogleSignInProvider>(context,
                                listen: false)
                            .userSearchingToogle(tempEagerValue);
                      }
                      isEagerToWork = uploadResult;
                      setState(() {});
                    } else {
                      widget.ifNoInternetGoBack();
                    }
                  }, !isEagerToWork),
                if (!widget.currentUser.isAccountTypeUser)
                  button(Icons.ad_units, 'Moje Ogłoszenia', () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyOffers(
                                  isAccountTypeUser:
                                      widget.currentUser.isAccountTypeUser,
                                  userId: widget.currentUser.userId,
                                )));
                  }, null),
                const SizedBox(height: 6),
                button(Icons.favorite_border, 'Moje Ulubione', () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SavedOffers(
                                isAccountTypeUser:
                                    widget.currentUser.isAccountTypeUser,
                                accountFavAds: widget.currentUser.likedOffers,
                                userId: widget.currentUser.userId,
                              )));
                }, null),
                const SizedBox(height: 6),
                button(Icons.logout_outlined, 'Wyloguj Się', () {
                  Navigator.pop(context);
                  Provider.of<GoogleSignInProvider>(context, listen: false)
                      .logout();
                }, null)
              ],
            ),
          ),
        )
      ],
    )));
  }

  Widget button(IconData icon, String text, Function function, bool? isEager) =>
      Container(
        decoration: BoxDecoration(
            color: isEager == null
                ? Colors.white24
                : isEager == true
                    ? Colors.white24
                    : const Color.fromARGB(112, 106, 245, 108)),
        height: 60,
        width: double.maxFinite,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => function(),
            splashFactory: InkRipple.splashFactory,
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(icon, color: Colors.white),
              const SizedBox(width: 10),
              Text(
                text,
                style: fontSize16,
                overflow: TextOverflow.ellipsis,
              )
            ]),
          ),
        ),
      );
}
