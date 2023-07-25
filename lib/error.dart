import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prakty/providers/provider.dart';
import 'package:provider/provider.dart';

class ErrorMessage extends StatelessWidget {
  const ErrorMessage({super.key});

  @override
  Widget build(BuildContext context) {
    var signInProvider =
        Provider.of<GoogleSignInProvider>(context, listen: false);
    return Stack(children: [
      InkWell(
          onTap: () async {
            if (await signInProvider.checkInternetConnectivity() == true) {
              signInProvider.toogleErrorMessage();
            }
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
                    Text('Napotkaliśmy Problem',
                        style: GoogleFonts.overpass(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Text(
                      textAlign: TextAlign.center,
                      signInProvider.createMessage(null),
                      style: GoogleFonts.overpass(
                        color: Colors.white,
                      ),
                    ),
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
                            if (await signInProvider
                                    .checkInternetConnectivity() ==
                                true) {
                              signInProvider.toogleErrorMessage();
                            }
                          },
                        )),
                  ])))),
    ]);
  }
}
