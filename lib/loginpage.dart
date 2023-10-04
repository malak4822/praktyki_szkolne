import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prakty/providers/edituser.dart';
import 'package:prakty/providers/googlesign.dart';
import 'package:prakty/widgets/inputwindows.dart';
import 'package:provider/provider.dart';

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

  @override
  Widget build(BuildContext context) {
    final signInProvider =
        Provider.of<GoogleSignInProvider>(context, listen: false);

    Future<bool> isInternet() async {
      return await Provider.of<EditUser>(context, listen: false)
          .checkInternetConnectivity();
    }

    bool hasInternet = false;

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
                            opacity: !_isLoginClicked ? 1 : 0,
                            curve: Curves.linearToEaseOut,
                            duration: const Duration(milliseconds: 500),
                            child: Visibility(
                                visible: !_isLoginClicked,
                                child: MyTextFormField(
                                  isTextObscured: false,
                                  myEndingIcon: null,
                                  myController: nameCont,
                                  myHintText: 'Imię I Nazwisko',
                                  myPrefixIcon: const Icon(Icons.person),
                                  myKeyboardType: TextInputType.name,
                                  fieldNumber: 0,
                                )))),
                    const SizedBox(height: 15),
                    MyTextFormField(
                      isTextObscured: false,
                      myEndingIcon: null,
                      myController: mailCont,
                      myHintText: 'Email',
                      myPrefixIcon: const Icon(Icons.email),
                      myKeyboardType: TextInputType.emailAddress,
                      fieldNumber: 1,
                    ),
                    const SizedBox(height: 15),
                    MyTextFormField(
                      isTextObscured: isTextObscured,
                      myEndingIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isTextObscured = !isTextObscured;
                            });
                          },
                          icon: Icon(isTextObscured
                              ? Icons.remove_red_eye_outlined
                              : Icons.remove_red_eye),
                          color: Colors.white),
                      myController: passCont,
                      myHintText: 'Hasło',
                      myPrefixIcon: const Icon(Icons.key_rounded),
                      myKeyboardType: TextInputType.visiblePassword,
                      fieldNumber: 2,
                    ),
                    const SizedBox(height: 15),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  side: _isLoginClicked
                                      ? const BorderSide(
                                          color: Colors.white, width: 2)
                                      : BorderSide.none,
                                  borderRadius: const BorderRadius.horizontal(
                                      left: Radius.circular(15))),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 15)),
                          onPressed: () async {
                            if (_isLoginClicked) {
                              if (await isInternet()) {
                                await signInProvider.loginViaEmailAndPassword(
                                    mailCont.text, passCont.text);

                                _formKey.currentState!.validate();
                              }
                            }
                            setState(() {
                              _isLoginClicked = true;
                            });
                          },
                          child: Text("Zaloguj",
                              style: GoogleFonts.overpass(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600))),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  side: !_isLoginClicked
                                      ? const BorderSide(
                                          color: Colors.white, width: 2)
                                      : BorderSide.none,
                                  borderRadius: const BorderRadius.horizontal(
                                      right: Radius.circular(15))),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 15)),
                          onPressed: () async {
                            if (!_isLoginClicked) {
                              if (await isInternet()) {
                                await signInProvider.signUpViaEmail(
                                    mailCont.text,
                                    passCont.text,
                                    nameCont.text);

                                _formKey.currentState!.validate();
                              }
                            }

                            setState(() {
                              _isLoginClicked = false;
                            });
                          },
                          child: Text(
                            "Zarejestruj",
                            style: GoogleFonts.overpass(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ))
                    ]),
                    Column(children: [
                      Directionality(
                          textDirection: TextDirection.rtl,
                          child: ElevatedButton.icon(
                              onPressed: () async {
                                hasInternet = await isInternet();
                                if (hasInternet) {
                                  try {
                                    await signInProvider.loginViaGoogle();
                                  } catch (e) {
                                    debugPrint(e.toString());
                                  }
                                }
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
