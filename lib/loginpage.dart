import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prakty/constants.dart';
import 'package:prakty/providers/edituser.dart';
import 'package:prakty/providers/googlesign.dart';
import 'package:prakty/widgets/inputwindows.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

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


   Future<bool> isInternet() async {
      return await Provider.of<EditUser>(context, listen: false)
          .checkInternetConnectivity();
    }



  @override
  Widget build(BuildContext context) {
    final signInProvider =
        Provider.of<GoogleSignInProvider>(context, listen: false);

// BŁĄDPRZY LOGOWANIU, CO NAJMNIEJ JEDNA WIELKA LITERA, JAK KILKNIE SIE 2 RAZY TO LOGUJE
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
                            duration: const Duration(milliseconds: 700),
                            child: Visibility(
                                visible: !_isLoginClicked,
                                child: MyTextFormField(
                                  isTextObscured: false,
                                  myEndingIcon: null,
                                  myController: nameCont,
                                  myHintText: 'Imię I Nazwisko',
                                  myPrefixIcon: const Icon(Icons.person),
                                  myKeyboardType: TextInputType.name,
                                )))),
                    const SizedBox(height: 15),
                    MyTextFormField(
                      isTextObscured: false,
                      myEndingIcon: null,
                      myController: mailCont,
                      myHintText: 'Email',
                      myPrefixIcon: const Icon(Icons.email),
                      myKeyboardType: TextInputType.emailAddress,
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
                    ),
                    const SizedBox(height: 12),
                    AnimatedSize(
                        curve: Curves.ease,
                        duration: const Duration(milliseconds: 300),
                        child: AnimatedOpacity(
                            opacity: !_isLoginClicked ? 1 : 0,
                            curve: Curves.linearToEaseOut,
                            duration: const Duration(milliseconds: 700),
                            child: Visibility(
                                visible: !_isLoginClicked,
                                child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 2, color: Colors.white),
                                        borderRadius:
                                            BorderRadius.circular(16)),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 12),
                                    child: DropdownButton<bool>(
                                        dropdownColor: const Color.fromARGB(
                                            255, 1, 192, 209),
                                        isExpanded: true,
                                        borderRadius: BorderRadius.circular(16),
                                        icon: const Icon(Icons.arrow_drop_down,
                                            color: Colors.white),
                                        underline: const SizedBox(),
                                        value:
                                            Provider.of<GoogleSignInProvider>(
                                                    context,
                                                    listen: false)
                                                .getCurrentUser
                                                .isAccountTypeUser,
                                        onChanged: (newValue) => setState(() {
                                              signInProvider
                                                  .toogleAccountType(newValue);
                                            }),
                                        items: <bool>[true, false]
                                            .map((bool value) {
                                          return DropdownMenuItem<bool>(
                                              value: value,
                                              child: Row(children: [
                                                Icon(
                                                    value == false
                                                        ? Icons.business
                                                        : Icons.school,
                                                    color: Colors.white),
                                                const SizedBox(width: 10),
                                                Text(
                                                    value
                                                        ? 'Konto Ucznia'
                                                        : 'Konto Pracodawcy',
                                                    style: fontSize16,
                                                    textAlign:
                                                        TextAlign.center),
                                              ]));
                                        }).toList()))))),
                    const SizedBox(height: 12),
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
                          child: Text("Zaloguj", style: fontSize20)),
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
                            style: fontSize20,
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

  @override
  void dispose() {
    nameCont.dispose();
    mailCont.dispose();
    passCont.dispose();
    super.dispose();
  }
}
