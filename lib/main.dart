import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:prakty/error.dart';
import 'package:prakty/loginpage.dart';
import 'package:prakty/welcome.dart';
import 'package:prakty/providers/provider.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => GoogleSignInProvider(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Prakty',
          theme: ThemeData(
              elevatedButtonTheme: ElevatedButtonThemeData(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color.fromARGB(255, 43, 43, 43))))),
          home: const MyHomePage(title: 'Prakty'),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    bool showErrorMessage =
        Provider.of<GoogleSignInProvider>(context).showErrorMessage;
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 33, 33, 33),
        body: Center(
          child: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Stack(
                  children: [
                    const WelcomePage(),
                    Center(
                        child: Visibility(
                            visible: showErrorMessage,
                            child: const ErrorMessage())),
                  ],
                );
              } else {
                return Stack(
                  children: [
                    const LoginPage(),
                    Center(
                        child: Visibility(
                            visible: showErrorMessage,
                            child: const ErrorMessage())),
                  ],
                );
              }
            },
          ),
        ));
  }
}
