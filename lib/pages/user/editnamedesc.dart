import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prakty/constants.dart';
import 'package:prakty/widgets/choselocation.dart';
import 'package:prakty/widgets/inputwindows.dart';

class EditNameAndDesc extends StatefulWidget {
  const EditNameAndDesc(
      this.nameCont,
      this.descriptionCont,
      this.locationCont,
      this.placeId,
      this.emailCont,
      this.ageCont,
      this.ageCallback,
      this.placeCallBack,
      this.isAccountTypeUser,
      this.formKey,
      {super.key});

  final String? placeId;
  final TextEditingController nameCont;
  final TextEditingController descriptionCont;
  final TextEditingController emailCont;
  final bool isAccountTypeUser;
  final TextEditingController locationCont;
  final GlobalKey<FormState> formKey;

  final int? ageCont;
  final Function placeCallBack;
  final Function ageCallback;

  @override
  State<EditNameAndDesc> createState() => _EditNameAndDescState();
}

class _EditNameAndDescState extends State<EditNameAndDesc> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
      child: Form(
          key: widget.formKey,
          child: Center(
              child: ListView(shrinkWrap: true, children: [
            updateValues(widget.nameCont, 'Imię I Nazwisko', 1, 24,
                Icons.face_sharp, TextInputType.name, null),
            const SizedBox(height: 10),
            updateValues(widget.descriptionCont, 'Opis', 8, 500,
                Icons.description_rounded, TextInputType.text, null),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.location_on_sharp, color: Colors.white),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FindOnMap(callBack:
                                            (String val, String placeRef) {
                                          setState(() {
                                            widget.locationCont.text = val;
                                          });

                                          widget.placeCallBack(placeRef);
                                        })));
                          },
                          child: Center(
                              child: Text(
                            widget.locationCont.text.isEmpty
                                ? 'Miejsce'
                                : widget.locationCont.text,
                            style: fontSize16,
                            textAlign: TextAlign.center,
                          ))),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 16),
            Row(children: [
              const Icon(Icons.person, color: Colors.white),
              const SizedBox(width: 16),
              Expanded(
                  child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: CupertinoPicker(
                          itemExtent: 18,
                          scrollController: FixedExtentScrollController(
                              initialItem: widget.ageCont != null
                                  ? widget.ageCont! - 14
                                  : 0),
                          onSelectedItemChanged: (int newVal) =>
                              widget.ageCallback(newVal + 14),
                          children: List.generate(
                              14 + 27,
                              (index) => Text('${(14 + index).toString()} lat',
                                  style: fontSize16))))),
            ]),
          ]))),
    );
  }
}

// TODO: REFACTOR / CLEAN CODE IN INPUTWINDOWS.DART
