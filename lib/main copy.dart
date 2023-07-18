import 'package:flutter/material.dart';
import 'package:prakty/providers/provider.dart';
import 'package:provider/provider.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              Provider.of<GoogleSignInProvider>(context, listen: false).logout();
            },
            child: const Icon(Icons.exit_to_app)),
      ),
    );
  }
}
