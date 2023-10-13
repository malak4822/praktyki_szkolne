import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prakty/constants.dart';
import 'package:prakty/widgets/inputwindows.dart';

class EditNameAndDesc extends StatefulWidget {
  const EditNameAndDesc(this.nameCont, this.descriptionCont, this.locationCont,
      this.ageCont, this.callback,
      {super.key});

  final TextEditingController nameCont;
  final TextEditingController descriptionCont;
  final TextEditingController locationCont;
  final int ageCont;
  final Function callback;

  @override
  State<EditNameAndDesc> createState() => _EditNameAndDescState();
}

class _EditNameAndDescState extends State<EditNameAndDesc> {
  List<String> dropdownOptions = [
    'Option 1',
    'Option 2',
    'Option 3',
    'Option 4',
  ];
  String selectedOption = 'Option 1';
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
        child: ListView(children: [
          updateValues(widget.nameCont, 'Imię I Nazwisko', 1, 24,
              Icons.face_sharp, TextInputType.name),
          const SizedBox(height: 10),
          updateValues(widget.descriptionCont, 'Opis', 8, 500,
              Icons.description_rounded, TextInputType.text),
          const SizedBox(height: 10),
          InkWell(
              onTap: () {
                Navigator.pushNamed(context, '/findOnMap');
              },
              child: TextField(
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    enabled: false,
                    icon: const Icon(Icons.location_on_rounded),
                    iconColor: Colors.white,
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    disabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Colors.white),
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                    ),
                    hintText: "Miejscowość",
                    hintStyle: GoogleFonts.overpass(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ))),
          const SizedBox(height: 10),
          Row(children: [
            const Icon(Icons.person, color: Colors.white),
            const SizedBox(width: 15),
            Expanded(
                child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 1),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: CupertinoPicker(
                        itemExtent: 18,
                        scrollController: FixedExtentScrollController(
                            initialItem: widget.ageCont),
                        onSelectedItemChanged: (int newVal) =>
                            widget.callback(newVal + 14),
                        children: List.generate(
                            14 + 27,
                            (index) => Text('${(14 + index).toString()} lat',
                                style: fontSize16))))),
          ])
        ]));
  }
}
