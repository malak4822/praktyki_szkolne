import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:prakty/constants.dart';
import 'package:prakty/loggedparent.dart';
import 'package:prakty/providers/edituser.dart';
import 'package:prakty/widgets/error.dart';
import 'package:prakty/loginpage.dart';
import 'package:prakty/providers/googlesign.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (c) => GoogleSignInProvider()),
          ChangeNotifierProvider(create: (c) => EditUser())
        ],
        child: MaterialApp(
          // routes: {
          //  '/userPage' : (context) => const UserPage(shownUser: shownUser, isOwnProfile: isOwnProfile)

          // },
          debugShowCheckedModeBanner: false,
          title: 'Prakty',
          theme: ThemeData(
              elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
                elevation: MaterialStateProperty.all(0),
                backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.white.withOpacity(0.2))),
          )),
          home: const MyHomePage(),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    bool loginConstrAccess = Provider.of<EditUser>(context).showErrorMessage;
    return Scaffold(
      body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: gradient),
          ),
          child: Center(
            child: Stack(children: [
              StreamBuilder<User?>(
                  stream: FirebaseAuth.instance.authStateChanges(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return const LoggedParentWidget();
                    } else {
                      return const LoginPage();
                    }
                  }),
              Visibility(
                  visible: loginConstrAccess, child: const ErrorMessage()),
            ]),
          )),
    );
  }
}
