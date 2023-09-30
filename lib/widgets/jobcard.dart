import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prakty/main.dart';

class JobNotice extends StatelessWidget {
  const JobNotice({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {},
        child: Container(
            decoration: BoxDecoration(
                boxShadow: myBoxShadow,
                gradient: const LinearGradient(colors: gradient),
                borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: SizedBox(
                height: 120,
                child: Row(children: [
                  Expanded(
                      flex: 3,
                      child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  'Firma numer dwdhwduhuwhd duwhduh whd',
                                  style: fontSize20,
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                    'to jest typowy opis firmy ji djwid jiw  dwd wdwdwdwd dhuwhdu whduwh duhd wuhduhwhduwdh wd uwhdu wduwwdwdwdw dw',
                                    maxLines: 3,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.overpass(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                                Row(
                                  children: [
                                    const Spacer(),
                                    const Icon(Icons.location_city,
                                        size: 18, color: Colors.white),
                                    Text(' Lokalizacja',
                                        maxLines: 1,
                                        style: GoogleFonts.overpass(
                                            fontSize: 12, color: Colors.white)),
                                    const Spacer(),
                                    const Icon(Icons.done,
                                        size: 18, color: Colors.white),
                                    Text(' Zdalne',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.overpass(
                                            fontSize: 12, color: Colors.white)),
                                    const Spacer(),
                                  ],
                                )
                              ]))),
                  const CircleAvatar(
                      radius: 52.5,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 50,
                        foregroundImage: NetworkImage(
                          'https://platinumlist.net/guide/wp-content/uploads/2023/03/IMG-worlds-of-adventure.webp',
                        ),
                      )),
                  const SizedBox(width: 10),
                ]))));
  }
}
