import 'package:animated_icon_button/animated_icon_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prakty/providers/provider.dart';
import 'package:prakty/widgets/inputwindows.dart';
import 'package:provider/provider.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

final myFont = GoogleFonts.overpass(
    fontSize: 14, color: const Color.fromARGB(255, 255, 120, 120));
const almostBlack = Color.fromARGB(255, 25, 25, 25);

class _LoginPageState extends State<LoginPage> {
  final TextEditingController nameCont = TextEditingController();
  final TextEditingController mailCont = TextEditingController();
  final TextEditingController passCont = TextEditingController();

  bool _isLoginClicked = true;
  bool isTextObscured = true;

  @override
  Widget build(BuildContext context) {
    final signInProvider =
        Provider.of<GoogleSignInProvider>(context, listen: false);
    final signInListenProvider = Provider.of<GoogleSignInProvider>(context);
    return Stack(children: [
      wciecia(Alignment.bottomRight, "images/login/login_bottomRight.png"),
      wciecia(Alignment.bottomLeft, "images/login/login_bottomLeft.png"),
      wciecia(Alignment.topRight, "images/login/login_topRight.png"),
      wciecia(Alignment.topLeft, "images/login/login_topLeft.png"),
      Column(
        children: [
          const Spacer(),
          AnimatedContainer(
            curve: Curves.linearToEaseOut,
            duration: const Duration(milliseconds: 400),
            width: _isLoginClicked ? 0 : MediaQuery.of(context).size.width,
            height: _isLoginClicked ? 0 : 60,
            child: Visibility(
              visible: !_isLoginClicked,
              child: logPut(false, null, nameCont, 'Użytkownik',
                  const Icon(Icons.person), TextInputType.name),
            ),
          ),
          const SizedBox(height: 15),
          logPut(false, null, mailCont, 'Email', const Icon(Icons.email),
              TextInputType.emailAddress),
          Visibility(
              visible: signInProvider.isEmailExists,
              child: Text('Konto z tym e-mailem już istnieje', style: myFont)),
          Visibility(
              visible: signInListenProvider.isEmailValidErrorShown,
              child: Text('Email jest nie poprawny', style: myFont)),
          const SizedBox(height: 15),
          logPut(
              isTextObscured,
              AnimatedIconButton(
                size: 24,
                animationDirection: const AnimationDirection.bounce(),
                onPressed: () async {
                  await Future.delayed(const Duration(milliseconds: 400), () {
                    setState(() {
                      isTextObscured = !isTextObscured;
                    });
                  });
                },
                duration: const Duration(milliseconds: 400),
                splashColor: Colors.transparent,
                icons: const <AnimatedIconItem>[
                  AnimatedIconItem(icon: Icon(Icons.remove_red_eye_outlined)),
                  AnimatedIconItem(icon: Icon(Icons.remove_red_eye)),
                ],
              ),
              passCont,
              'Hasło',
              const Icon(Icons.key_rounded),
              TextInputType.visiblePassword),
          Visibility(
              visible: signInListenProvider.isPassErrorShown,
              child: Text('Zbyt słabe hasło, popraw je', style: myFont)),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(30))),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15)),
                  onPressed: () {
                    setState(() {});
                    if (_isLoginClicked) {
                      // login
                    }
                    _isLoginClicked = true;
                  },
                  child: _isLoginClicked
                      ? GradientText(
                          'Zaloguj',
                          style: const TextStyle(fontSize: 21),
                          colors: const [
                            Color.fromARGB(255, 120, 239, 255),
                            Color.fromARGB(255, 98, 255, 156)
                          ],
                        )
                      : Text(
                          "Zaloguj",
                          style: GoogleFonts.overpass(fontSize: 20),
                        )),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: almostBlack,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.horizontal(
                              right: Radius.circular(30))),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15)),
                  onPressed: () {
                    if (!_isLoginClicked) {
                      // CHECK IF DATA IS CORRECT
                      signInProvider.createName(nameCont.text);
                      signInProvider.createUser(mailCont.text, passCont.text);
                    }
                    setState(() {
                      _isLoginClicked = false;
                    });
                  },
                  child: _isLoginClicked
                      ? Text(
                          "Zarejestruj",
                          style: GoogleFonts.overpass(fontSize: 20),
                        )
                      : GradientText(
                          'Zarejestruj',
                          style: const TextStyle(fontSize: 21),
                          colors: const [
                            Color.fromARGB(255, 120, 239, 255),
                            Color.fromARGB(255, 98, 255, 156)
                          ],
                        )),
            ],
          ),
          Column(
            children: [
              Directionality(
                textDirection: TextDirection.rtl,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const FaIcon(FontAwesomeIcons.google),
                  label: const Text("Zarejestruj się przez"),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.fromLTRB(30, 10, 35, 10),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(bottom: Radius.circular(50))),
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
        ],
      )
    ]);
  }

  wciecia(Alignment place, String path) {
    return Align(
        alignment: place,
        child: FadeInImage(
          height: MediaQuery.of(context).size.height / 6,
          placeholderFit: BoxFit.scaleDown,
          fadeInDuration: const Duration(milliseconds: 500),
          image: AssetImage((path)),
          placeholder: AssetImage((path)),
        ));
  }
}
