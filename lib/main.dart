import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:prakty/providers/loginconstrains.dart';
import 'package:prakty/widgets/error.dart';
import 'package:prakty/loginpage.dart';
import 'package:prakty/welcome.dart';
import 'package:prakty/providers/googlesign.dart';
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
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (c) => GoogleSignInProvider()),
          ChangeNotifierProvider(create: (c) => LoginConstrains())
        ],
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
    bool loginConstrAccess =
        Provider.of<LoginConstrains>(context).showErrorMessage;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 33, 33, 33),
      body: Center(
        child: Stack(children: [
          StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return const WelcomePage();
                } else {
                  return const LoginPage();
                }
              }),
          Visibility(visible: loginConstrAccess, child: const ErrorMessage()),
        ]),
      ),
    );
  }
}
