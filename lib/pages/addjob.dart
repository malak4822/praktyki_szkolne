import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prakty/main.dart';
import 'package:prakty/widgets/inputwindows.dart';

class AddJob extends StatefulWidget {
  const AddJob({super.key});

  @override
  State<AddJob> createState() => _AddJobState();
}

class _AddJobState extends State<AddJob> {
  TextEditingController jobName = TextEditingController();
  TextEditingController companyName = TextEditingController();
  TextEditingController jobEmail = TextEditingController();
  TextEditingController jobPhone = TextEditingController();
  TextEditingController jobLocation = TextEditingController();
  TextEditingController jobQualification = TextEditingController();
  TextEditingController jobDescription = TextEditingController();

  File? noticePhoto;

  Future<void> pickImg() async {
    final imagePicker = ImagePicker();

    final pickedImage = await imagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 18);
    if (pickedImage != null) {
      setState(() {
        noticePhoto = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                    decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: gradient),
                        boxShadow: myBoxShadow,
                        borderRadius: BorderRadius.circular(20)),
                    child: Center(
                      child: ListView(
                          padding: const EdgeInsets.all(20),
                          children: [
                            Stack(children: [
                              if (noticePhoto != null)
                                GestureDetector(
                                  onTap: () async {
                                    await pickImg();
                                  },
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: SizedBox(
                                          width: double.infinity,
                                          height: 220,
                                          child: Image(
                                            fit: BoxFit.cover,
                                            image: noticePhoto != null
                                                ? FileImage(noticePhoto!)
                                                : const NetworkImage(
                                                        'https://clipart-library.com/new_gallery/1-15633_no-sign-png-no-symbol-white-png.png')
                                                    as ImageProvider<Object>,
                                          ))),
                                ),
                              Container(
                                width: 40,
                                height: 52,
                                decoration: BoxDecoration(
                                    color: noticePhoto != null
                                        ? const Color.fromARGB(
                                            255, 49, 182, 209)
                                        : Colors.transparent,
                                    borderRadius: const BorderRadius.only(
                                      bottomRight: Radius.circular(20),
                                    )),
                                child: IconButton(
                                    alignment: Alignment.topLeft,
                                    iconSize: 34,
                                    onPressed: () => Navigator.pop(context),
                                    icon: const Icon(Icons.arrow_back_ios,
                                        color: Colors.white)),
                              ),
                            ]),
                            if (noticePhoto == null)
                              IconButton(
                                  iconSize: 42,
                                  icon: const Icon(
                                    Icons.photo,
                                    color: Colors.white,
                                  ),
                                  onPressed: () async {
                                    await pickImg();
                                  }),
                            const SizedBox(height: 15),
                            updateValues(jobName, 'Nazwa Stanowiska', 1, 28,
                                Icons.person),
                            const SizedBox(height: 8),
                            updateValues(companyName, 'Nazwa Firmy', 1, 24,
                                Icons.business),
                            const SizedBox(height: 8),
                            updateValues(jobEmail, 'Email Kontaktowy', 1, 24,
                                Icons.email),
                            const SizedBox(height: 8),
                            updateValues(jobPhone, 'Telefon Kontaktowy', 1, 9,
                                Icons.phone),
                            const SizedBox(height: 8),
                            updateValues(jobLocation, 'Miejsce Praktyk', 1, 28,
                                Icons.place),
                            const SizedBox(height: 8),
                            updateValues(jobQualification, 'Nazwa Kwalifikacji',
                                1, 28, Icons.text_fields_rounded),
                            const SizedBox(height: 8),
                            updateValues(jobDescription, 'Opis Stanowiska', 1,
                                30, Icons.description_outlined),
                          ]),
                    )))));
  }
}
