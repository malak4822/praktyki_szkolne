import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:prakty/constants.dart';
import 'package:prakty/providers/edituser.dart';
import 'package:prakty/providers/googlesign.dart';
import 'package:prakty/services/database.dart';
import 'package:provider/provider.dart';

Widget backButton(BuildContext context) => GestureDetector(
    onTap: () {
      if (context.mounted) {
        Navigator.pop(context);
      }
    },
    child: Container(
        width: 62,
        height: 62,
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
            color: Color.fromARGB(255, 49, 182, 209),
            borderRadius: BorderRadius.only(bottomRight: Radius.circular(62))),
        child: const Icon(Icons.arrow_back_ios_rounded,
            color: Colors.white, size: 28)));

class HeartButton extends StatefulWidget {
  const HeartButton(
      {super.key,
      required this.isOnUserPage,
      required this.userId,
      required this.noticeId,
      required this.initialValue});
  final bool isOnUserPage;
  final String noticeId;
  final String userId;
  final double initialValue;

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
      value: widget.initialValue,
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
    return Align(
        alignment: Alignment.topRight,
        child: GestureDetector(
          onTap: () async {
            if (await Provider.of<EditUser>(context, listen: false)
                .checkInternetConnectivity()) {
              String successfullyToggled = await MyDb().saveFav(
                _animationController.isCompleted,
                widget.userId,
                widget.noticeId,
              );

              if (successfullyToggled == 'success') {
                setState(() {
                  if (_animationController.isCompleted) {
                    _animationController.reverse();
                    Provider.of<GoogleSignInProvider>(context, listen: false)
                        .removeNoticeFromFav = widget.noticeId;
                  } else {
                    _animationController.forward();
                    Provider.of<GoogleSignInProvider>(context, listen: false)
                        .addNoticeToFav = widget.noticeId;
                  }
                });
              } else {
                if (context.mounted) {
                  Provider.of<EditUser>(context)
                      .showErrorBox(successfullyToggled);
                }
              }
            }
          },
          child: Container(
              alignment: Alignment.topRight,
              width: 62,
              height: 62,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius:
                      const BorderRadius.only(bottomLeft: Radius.circular(72)),
                  color: widget.isOnUserPage ? Colors.white : gradient[1]),
              child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) => Transform.scale(
                        scale: _sizeAnimation.value,
                        alignment: Alignment.center,
                        child: Icon(
                            color: widget.isOnUserPage
                                ? gradient[1]
                                : Colors.white,
                            _animationController.isCompleted
                                ? FontAwesomeIcons.solidHeart
                                : FontAwesomeIcons.heart,
                            size: 28),
                      ))),
        ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

