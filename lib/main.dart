import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prakty/loggedparent.dart';
import 'package:prakty/pages/edituserpage.dart';
import 'package:prakty/providers/edituser.dart';
import 'package:prakty/providers/loginconstrains.dart';
import 'package:prakty/widgets/error.dart';
import 'package:prakty/loginpage.dart';
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
          initialRoute: '/root',
          routes: {
            '/root': (context) => const MyHomePage(),
            '/editUser': (context) => ChangeNotifierProvider<EditUser>(
                  create: (context) => EditUser(),
                  child: EditUserPage(),
                )
          },
          debugShowCheckedModeBanner: false,
          title: 'Prakty',
          theme: ThemeData(
              elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
                elevation: MaterialStateProperty.all(0),
                backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.white.withOpacity(0.8))),
          )),
          home: const MyHomePage(),
        ));
  }
}

final fontSize20 = GoogleFonts.overpass(
    fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white);
final fontSize16 = GoogleFonts.overpass(
    fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white);

final myErrorFont = GoogleFonts.overpass(
    fontSize: 14, color: const Color.fromARGB(255, 255, 120, 120));

const List<Color> gradient = [
  Color.fromARGB(255, 103, 242, 255),
  Color.fromARGB(255, 0, 162, 226)
];

// const List<Color> gradient = [
//   Colors.purple,
//   Colors.blue,
// ];

const Color blackie = Color.fromARGB(255, 0, 79, 110);

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    bool loginConstrAccess =
        Provider.of<LoginConstrains>(context).showErrorMessage;
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
                      Provider.of<GoogleSignInProvider>(context, listen: false)
                          .setUserOnStart(context);
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
