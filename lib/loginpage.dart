import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prakty/main.dart';
import 'package:prakty/providers/googlesign.dart';
import 'package:prakty/widgets/inputwindows.dart';
import 'package:provider/provider.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController nameCont = TextEditingController();
  final TextEditingController mailCont = TextEditingController();
  final TextEditingController passCont = TextEditingController();
  bool _isLoginClicked = true;
  bool isTextObscured = true;

  final _formKey = GlobalKey<FormState>();

  double myOpacity() {
    if (!_isLoginClicked) {
      return 1;
    } else {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final signInProvider =
        Provider.of<GoogleSignInProvider>(context, listen: false);

    return Stack(children: [
      wciecia(Alignment.bottomRight, "images/login/login_bottomRight.png"),
      wciecia(Alignment.bottomLeft, "images/login/login_bottomLeft.png"),
      wciecia(Alignment.topRight, "images/login/login_topRight.png"),
      wciecia(Alignment.topLeft, "images/login/login_topLeft.png"),
      Center(
          child: ConstrainedBox(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 4 / 5),
              child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                      child: Column(children: [
                    AnimatedSize(
                        curve: Curves.ease,
                        duration: const Duration(milliseconds: 300),
                        child: AnimatedOpacity(
                            opacity: myOpacity(),
                            curve: Curves.linearToEaseOut,
                            duration: const Duration(milliseconds: 500),
                            // width: _isLoginClicked ? 0 : null,
                            // height: _isLoginClicked ? 0 : null,
                            child: Visibility(
                                visible: !_isLoginClicked,
                                child: textFormField(
                                    false,
                                    null,
                                    nameCont,
                                    'Imię I Nazwisko',
                                    const Icon(Icons.person),
                                    TextInputType.name,
                                    '')))),
                    const SizedBox(height: 15),
                    textFormField(
                        false,
                        null,
                        mailCont,
                        'Email',
                        const Icon(Icons.email),
                        TextInputType.emailAddress,
                        ''),
                    const SizedBox(height: 15),
                    textFormField(
                        isTextObscured,
                        IconButton(
                            onPressed: () {
                              setState(() {
                                isTextObscured = !isTextObscured;
                              });
                            },
                            icon: Icon(isTextObscured
                                ? Icons.remove_red_eye_outlined
                                : Icons.remove_red_eye),
                            color: Colors.white),
                        // AnimatedIconButton(
                        //   size: 24,
                        //   animationDirection: const AnimationDirection.bounce(),
                        //   onPressed: () async {
                        //     await Future.delayed(
                        //         const Duration(milliseconds: 400), () {
                        //       setState(() {
                        //         isTextObscured = !isTextObscured;
                        //       });
                        //     });
                        //   },
                        //   duration: const Duration(milliseconds: 400),
                        //   icons: const <AnimatedIconItem>[
                        //     AnimatedIconItem(
                        //         icon: Icon(Icons.remove_red_eye_outlined,
                        //             color: Colors.white)),
                        //     AnimatedIconItem(
                        //         icon: Icon(Icons.remove_red_eye,
                        //             color: Colors.white)),
                        //   ],
                        // ),
                        passCont,
                        'Hasło',
                        const Icon(Icons.key_rounded),
                        TextInputType.visiblePassword,
                        ''),
                    const SizedBox(height: 15),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                  side:
                                      BorderSide(color: Colors.white, width: 2),
                                  borderRadius: BorderRadius.horizontal(
                                      left: Radius.circular(15))),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 15)),
                          onPressed: () async {
                            if (_isLoginClicked) {
                              if (_formKey.currentState!.validate()) {
                                signInProvider.loginViaEmailAndPassword(
                                    mailCont.text, passCont.text, context);
                              }
                            }
                            setState(() {
                              _isLoginClicked = true;
                            });
                          },
                          child: _isLoginClicked
                              ? GradientText(
                                  'Zaloguj',
                                  style: fontSize20,
                                  colors: gradient,
                                )
                              : Text(
                                  "Zaloguj",
                                  style: GoogleFonts.overpass(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                )),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                  side:
                                      BorderSide(color: Colors.white, width: 2),
                                  borderRadius: BorderRadius.horizontal(
                                      right: Radius.circular(15))),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 15)),
                          onPressed: () {
                            if (!_isLoginClicked) {
                              if (_formKey.currentState!.validate()) {
                                signInProvider.signUpViaEmail(mailCont.text,
                                    passCont.text, nameCont.text, context);
                              }
                            }

                            setState(() {
                              _isLoginClicked = false;
                            });
                          },
                          child: _isLoginClicked
                              ? Text(
                                  "Zarejestruj",
                                  style: GoogleFonts.overpass(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                )
                              : GradientText('Zarejestruj',
                                  style: fontSize20, colors: gradient))
                    ]),
                    Column(children: [
                      Directionality(
                          textDirection: TextDirection.rtl,
                          child: ElevatedButton.icon(
                              onPressed: () async {
                                await signInProvider.loginViaGoogle(context);
                              },
                              icon: const FaIcon(FontAwesomeIcons.google,
                                  size: 14, color: Colors.white),
                              label: Text("Loguj przez",
                                  style: GoogleFonts.overpass(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.fromLTRB(30, 10, 35, 10),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                shape: const RoundedRectangleBorder(
                                    // side: BorderSide(
                                    //     width: 2, color: Colors.white),
                                    borderRadius: BorderRadius.vertical(
                                        bottom: Radius.circular(15))),
                              )))
                    ]),
                  ])))))
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
