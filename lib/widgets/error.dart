import 'package:flutter/material.dart';
import 'package:prakty/providers/loginconstrains.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class ErrorMessage extends StatelessWidget {
  const ErrorMessage({super.key});

  @override
  Widget build(BuildContext context) {
    var loginConstrAccess =
        Provider.of<LoginConstrains>(context, listen: false);
    return Stack(children: [
      InkWell(
          onTap: () async {
            await loginConstrAccess.checkInternetConnectivity();
          },
          child: Container(color: Colors.white.withOpacity(0.6))),
      Center(
          child: Container(
              width: MediaQuery.of(context).size.width * 3 / 4,
              height: MediaQuery.of(context).size.height / 3,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.black.withOpacity(0.85)),
              child: Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    const SizedBox(height: 20),
                    Text('Houston, Mamy Problem',
                        style: fontSize20),
                    const Spacer(),
                    SingleChildScrollView(
                        child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              Provider.of<LoginConstrains>(context).errorText,
                              textAlign: TextAlign.center,
                              style: fontSize16,
                            ))),
                    const Spacer(),
                    SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      bottom: Radius.circular(30))),
                              padding: const EdgeInsets.all(15)),
                          child: const Icon(Icons.restart_alt,
                              size: 32, color: Colors.white),
                          onPressed: () async {
                            await loginConstrAccess.checkInternetConnectivity();
                          },
                        )),
                  ])))),
    ]);
  }
}
