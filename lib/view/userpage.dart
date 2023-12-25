import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prakty/constants.dart';
import 'package:prakty/models/user_model.dart';
import 'package:prakty/providers/edituser.dart';
import 'package:prakty/providers/googlesign.dart';
import 'package:prakty/widgets/contactbox.dart';
import 'package:prakty/widgets/loadingscreen.dart';
import 'package:provider/provider.dart';
import '../widgets/skillboxes.dart';

class UserPage extends StatelessWidget {
  UserPage({super.key, required this.shownUser, required this.isOwnProfile});

  final MyUser shownUser;
  final bool isOwnProfile;

  Future<dynamic> _getUser(BuildContext context) {
    if (isOwnProfile) {
      MyUser myUser = Provider.of<GoogleSignInProvider>(context, listen: false)
          .getCurrentUser;
      return Future.value(myUser);
    } else {
      return Future.value(shownUser);
    }
  }

  @override
  Widget build(BuildContext context) {
    var userData = shownUser;
    return FutureBuilder(
        future: _getUser(context),
        builder: (builder, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingWidget();
          } else {
            userData = snapshot.data;
            return Scaffold(
                body: ListView(children: [
              SizedBox(
                  height: 200,
                  child: Stack(children: [
                    Container(
                        height: 140,
                        decoration: const BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black38,
                                  spreadRadius: 0.1,
                                  blurRadius: 12,
                                  offset: Offset(0, 6))
                            ],
                            gradient: LinearGradient(colors: gradient),
                            borderRadius: BorderRadius.vertical(
                                bottom: Radius.elliptical(200, 30)))),
                    Align(
                      alignment: Alignment.topRight,
                      child: Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Container(
                            width: 68,
                            height: 58,
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(100)),
                                color: Colors.white),
                            padding: const EdgeInsets.all(14),
                          ),
                          if (isOwnProfile)
                            IconButton(
                                iconSize: isOwnProfile ? 22 : 26,
                                icon: FaIcon(FontAwesomeIcons.userPen,
                                    color: gradient[1]),
                                onPressed: () {
                                  if (isOwnProfile) {
                                    Provider.of<EditUser>(context,
                                            listen: false)
                                        .checkEmptiness(
                                            userData.username,
                                            userData.description ?? '',
                                            userData.isAccountTypeUser
                                                ? userData.age
                                                : 1,
                                            userData.isAccountTypeUser
                                                ? userData.location
                                                : 'a');

                                    Navigator.pushNamed(context, '/editUser');
                                  } else {
                                    GestureDetector(
                                      onTap: () {
                                        Provider.of<EditUser>(context,
                                                listen: false)
                                            .toogleAddToFav(shownUser.userId);
                                      },
                                    );
                                  }
                                }),
                          if (!isOwnProfile) const HeartButton()
                        ],
                      ),
                    ),
                    Center(
                        child: CircleAvatar(
                            radius: 85,
                            backgroundColor: Colors.white,
                            child: Container(
                                height: 160,
                                width: 160,
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(colors: gradient)),
                                child: ClipOval(
                                    child: FadeInImage(
                                  fit: BoxFit.cover,
                                  fadeInDuration:
                                      const Duration(milliseconds: 500),
                                  image: NetworkImage(
                                    userData.profilePicture ??
                                        'https://firebasestorage.googleapis.com/v0/b/praktyki-szkolne.appspot.com/o/my_files%2Fman_praktyki.png?alt=media&token=dec782e2-1e50-4066-b0b6-0dc8019463d8&_gl=1*5iyx8e*_ga*MTg3NTU1MzM0MC4xNjk4MzAyMTM5*_ga_CW55HF8NVT*MTY5OTI4NjY4OC42LjEuMTY5OTI4NjcwMS40Ny4wLjA.',
                                  ),
                                  placeholder: const NetworkImage(
                                      'https://firebasestorage.googleapis.com/v0/b/praktyki-szkolne.appspot.com/o/my_files%2Fman_praktyki.png?alt=media&token=dec782e2-1e50-4066-b0b6-0dc8019463d8&_gl=1*5iyx8e*_ga*MTg3NTU1MzM0MC4xNjk4MzAyMTM5*_ga_CW55HF8NVT*MTY5OTI4NjY4OC42LjEuMTY5OTI4NjcwMS40Ny4wLjA.'),
                                ))))),
                    if (!isOwnProfile)
                      IconButton(
                          alignment: Alignment.topLeft,
                          iconSize: 28,
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back_ios_rounded,
                              color: Colors.white)),
                  ])),
              Container(
                  margin: const EdgeInsets.symmetric(horizontal: 25),
                  decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: gradient),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: myBoxShadow),
                  child: Stack(children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Column(children: [
                        Center(
                            child: Text(userData.username,
                                softWrap: true,
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.overpass(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800))),
                        Visibility(
                            visible: userData.isAccountTypeUser,
                            child: Center(
                                child: Text(
                              textAlign: TextAlign.center,
                              userData.age != null
                                  ? '${userData.age == 0 ? '' : '${userData.age.toString()} ${getAgeSuffix(userData.age!)}'}${userData.location != '' ? ', ${userData.location}' : ''}'
                                  : '',
                              style: GoogleFonts.overpass(
                                  color: Colors.white, fontSize: 16),
                            ))),
                        const SizedBox(height: 5),
                        if (userData.description != null)
                          Text(userData.description!,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.overpass(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                      ]),
                    )
                  ])),
              Visibility(
                  visible: userData.skillsSet.isNotEmpty,
                  child: SizedBox(
                      height: 136,
                      child: Padding(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width / 13,
                              right: MediaQuery.of(context).size.width / 13,
                              top: 6),
                          child: Center(
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: userData.skillsSet.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) => skillBox(
                                      userData.skillsSet[index].keys.single,
                                      userData.skillsSet[index].values.single,
                                      context,
                                      true)))))),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Visibility(
                      visible: userData.email.isNotEmpty,
                      child: contactBox(Icons.email_rounded,
                          'mailto:${userData.email}', true)),
                  const SizedBox(width: 10),
                  Visibility(
                      visible: userData.phoneNum != '',
                      child: Row(
                        children: [
                          contactBox(
                              Icons.phone, 'tel:+48${userData.phoneNum}', true),
                          const SizedBox(width: 10),
                          contactBox(
                              Icons.sms, 'sms:+48${userData.phoneNum}', true),
                        ],
                      )),
                ],
              ),
              const SizedBox(height: 16),
            ]));
          }
        });
  }
}

class HeartButton extends StatefulWidget {
  const HeartButton({super.key});

  @override
  HeartButtonState createState() => HeartButtonState();
}

class HeartButtonState extends State<HeartButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _sizeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _sizeAnimation = TweenSequence<double>([
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 1.0, end: 1.3),
        weight: 50,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 1.3, end: 1.0),
        weight: 50,
      ),
    ]).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.slowMiddle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (_animationController.isCompleted) {
            _animationController.reverse();
          } else {
            _animationController.forward();
          }
        });
      },
      child: Padding(
          padding: const EdgeInsets.all(12),
          child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) => Transform.scale(
                    scale: _sizeAnimation.value,
                    alignment: Alignment.center,
                    child: Icon(
                      color: gradient[1],
                      _animationController.isCompleted
                          ? FontAwesomeIcons.solidHeart
                          : FontAwesomeIcons.heart,
                      size: 28,
                    ),
                  ))),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
