import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prakty/constants.dart';
import 'package:prakty/pages/user/choselocation.dart';
import 'package:prakty/widgets/inputwindows.dart';

class EditNameAndDesc extends StatefulWidget {
  EditNameAndDesc(this.nameCont, this.descriptionCont, this.locationCont,
      this.ageCont, this.callback,
      {super.key});

  final TextEditingController nameCont;
  final TextEditingController descriptionCont;
  TextEditingController locationCont;
  final int ageCont;
  final Function callback;

  @override
  State<EditNameAndDesc> createState() => _EditNameAndDescState();
}

class _EditNameAndDescState extends State<EditNameAndDesc> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
        child: ListView(children: [
          updateValues(widget.nameCont, 'Imię I Nazwisko', 1, 24,
              Icons.face_sharp, TextInputType.name, null),
          const SizedBox(height: 10),
          updateValues(widget.descriptionCont, 'Opis', 8, 500,
              Icons.description_rounded, TextInputType.text, null),
          const SizedBox(height: 10),
          updateValues(widget.locationCont, 'Miejsce', null, null,
              Icons.location_on_rounded, null, () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FindOnMap(callBack: (String val) {
                          setState(() {
                            widget.locationCont.text = val;
                          });
                        })));
          }),
          const SizedBox(height: 16),
          Row(children: [
            const Icon(Icons.person, color: Colors.white),
            const SizedBox(width: 16),
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
                            // BUG - FIX IT
                            14 + 27,
                            (index) => Text('${(14 + index).toString()} lat',
                                style: fontSize16))))),
          ])
        ]));
  }
}
