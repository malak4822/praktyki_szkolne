import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prakty/main.dart';
import 'package:prakty/widgets/inputwindows.dart';

class EditNameAndDesc extends StatelessWidget {
  const EditNameAndDesc(this.nameCont, this.descriptionCont, this.locationCont,
      this.ageCont, this.callback,
      {super.key});

  final TextEditingController nameCont;
  final TextEditingController descriptionCont;
  final TextEditingController locationCont;
  final int ageCont;
  final Function callback;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
        child: ListView(children: [
          updateValues(nameCont, 'Imię I Nazwisko', 1, 24, Icons.face_sharp,
              TextInputType.name),
          const SizedBox(height: 10),
          updateValues(descriptionCont, 'Opis', 8, 500,
              Icons.description_rounded, TextInputType.text),
          const SizedBox(height: 10),
          updateValues(locationCont, 'Lokalizacja', 1, 40,
              Icons.location_on_rounded, TextInputType.streetAddress),
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
                        itemExtent: 20,
                        scrollController:
                            FixedExtentScrollController(initialItem: ageCont),
                        onSelectedItemChanged: (int newVal) => callback(newVal),
                        children: List.generate(
                            27,
                            (index) => Text('${(index).toString()} lat',
                                style: fontSize16)))))
          ])
        ]));
  }
}
