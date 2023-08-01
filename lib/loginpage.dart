import 'package:animated_icon_button/animated_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prakty/providers/loginconstrains.dart';
import 'package:prakty/providers/googlesign.dart';
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
  void initState() {
    Provider.of<GoogleSignInProvider>(context, listen: false).getUsersIds();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final signInProvider =
        Provider.of<GoogleSignInProvider>(context, listen: false);

    final logConstrainsListener = Provider.of<LoginConstrains>(context);

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
              child: logPut(false, null, nameCont, 'Imię I Nazwisko',
                  const Icon(Icons.person), TextInputType.name),
            ),
          ),
          Visibility(
              visible: logConstrainsListener.isUsernameTooShort,
              child: Text('Sory Ale Imię I Nazwisko Jest Zbyt Krótkie',
                  style: myFont)),
          Visibility(
              visible: logConstrainsListener.isUsernameTooLong,
              child: Text('Imię I Nazwisko Może Mieć Maksymalnie 22 znaki',
                  style: myFont)),
          const SizedBox(height: 15),
          logPut(false, null, mailCont, 'Email', const Icon(Icons.email),
              TextInputType.emailAddress),
          Visibility(
              visible: logConstrainsListener.isEmailEmpty,
              child: Text('Sory Ale Musisz Wpisać Email', style: myFont)),
          Visibility(
              visible: logConstrainsListener.isUserFound,
              child: Text('Nie Ma Takiego Użytkownika :<', style: myFont)),
          Visibility(
              visible: logConstrainsListener.doEmailExist,
              child: Text('Sory Ale Konto z tym e-mailem już istnieje :<',
                  style: myFont)),
          Visibility(
              visible: logConstrainsListener.isEmailValidErrorShown,
              child: Text('Sory Ale Ten Email Nie Jest Poprawny :<',
                  style: myFont)),
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
                  AnimatedIconItem(
                      icon: Icon(Icons.remove_red_eye_outlined,
                          color: Colors.white)),
                  AnimatedIconItem(
                      icon: Icon(Icons.remove_red_eye, color: Colors.black)),
                ],
              ),
              passCont,
              'Hasło',
              const Icon(Icons.key_rounded),
              TextInputType.visiblePassword),
          Visibility(
              visible: logConstrainsListener.isPasswordWrong,
              child: Text('Sory Ale Jakiś Błąd Się Wkradł W Hasło :<',
                  style: myFont)),
          Visibility(
              visible: logConstrainsListener.isPasswdEmpty,
              child: Text('Sory Ale Musisz Wpisać Hasło', style: myFont)),
          Visibility(
              visible: logConstrainsListener.isPassErrorShown,
              child: Text('Sory Ale To Hasło Jest Zbyt Słabe', style: myFont)),
          const SizedBox(height: 15),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.horizontal(left: Radius.circular(30))),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15)),
                onPressed: () {
                  logConstrainsListener.clearWarnings();
                  if (_isLoginClicked) {
                    signInProvider.loginDesicion(mailCont.text, passCont.text,
                        LoggedVia.emailAndPassword, context);
                  }
                  setState(() {
                    _isLoginClicked = true;
                  });
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
                  logConstrainsListener.clearWarnings();
                  if (!_isLoginClicked) {
                    signInProvider.createUser(
                        mailCont.text, passCont.text, nameCont.text, context);
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
                    : GradientText('Zarejestruj',
                        style: const TextStyle(fontSize: 21),
                        colors: const [
                            Color.fromARGB(255, 120, 239, 255),
                            Color.fromARGB(255, 98, 255, 156)
                          ]))
          ]),
          Column(
            children: [
              Directionality(
                textDirection: TextDirection.rtl,
                child: ElevatedButton.icon(
                  onPressed: () {
                    signInProvider.loginDesicion(mailCont.text, passCont.text,
                        LoggedVia.google, context);
                  },
                  icon: const FaIcon(FontAwesomeIcons.google),
                  label: const Text("Loguj przez"),
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
      ),
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
