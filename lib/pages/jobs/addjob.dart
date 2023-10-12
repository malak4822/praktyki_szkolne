import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prakty/main.dart';
import 'package:prakty/providers/edituser.dart';
import 'package:prakty/providers/googlesign.dart';
import 'package:prakty/services/database.dart';
import 'package:prakty/widgets/inputwindows.dart';
import 'package:provider/provider.dart';

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
  bool canRemotely = false;
  File? noticePhoto;
  final _formKey = GlobalKey<FormState>();

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

  Future<void> addJobAd() async {
    try {
      await MyDb().addFirestoreJobAd(
          Provider.of<GoogleSignInProvider>(context, listen: false)
              .getCurrentUser
              .userId,
          noticePhoto ?? 'no_image',
          jobName.text,
          companyName.text,
          jobEmail.text,
          jobPhone.text,
          jobLocation.text,
          jobQualification.text,
          jobDescription.text,
          canRemotely);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Stack(children: [
      Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              gradient: const LinearGradient(colors: gradient),
              boxShadow: myBoxShadow,
              borderRadius: BorderRadius.circular(20)),
          child: Center(
              child: Form(
                  key: _formKey,
                  child: ListView(padding: const EdgeInsets.all(20), children: [
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
                        Icons.person, TextInputType.name),
                    const SizedBox(height: 16),
                    updateValues(companyName, 'Nazwa Firmy', 1, 24,
                        Icons.business, TextInputType.text),
                    const SizedBox(height: 16),
                    updateValues(jobEmail, 'Email Kontaktowy', 1, 24,
                        Icons.email, TextInputType.emailAddress),
                    const SizedBox(height: 16),
                    updateValues(jobPhone, 'Telefon', 1, 9, Icons.phone,
                        TextInputType.phone),
                    const SizedBox(height: 12),
                    updateValues(jobLocation, 'Miejsce Praktyk', 1, 28,
                        Icons.place, TextInputType.streetAddress),
                    const SizedBox(height: 16),
                    updateValues(jobQualification, 'Nazwa Kwalifikacji', 1, 28,
                        Icons.text_fields_rounded, TextInputType.text),
                    const SizedBox(height: 16),
                    updateValues(jobDescription, 'Opis Stanowiska', 10, 600,
                        Icons.description_outlined, TextInputType.text),
                    CheckboxListTile(
                        contentPadding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width / 5),
                        checkboxShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        activeColor: Colors.white,
                        side: MaterialStateBorderSide.resolveWith((states) =>
                            const BorderSide(width: 2, color: Colors.white)),
                        title: Text("Praca Zdalna", style: fontSize16),
                        value: canRemotely,
                        dense: true,
                        controlAffinity: ListTileControlAffinity.leading,
                        onChanged: (newValue) {
                          setState(() {
                            canRemotely = newValue!;
                          });
                        }),
                    const SizedBox(height: 16),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(8),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            backgroundColor: Colors.white24,
                            elevation: 20),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            if (await Provider.of<EditUser>(context,
                                    listen: false)
                                .checkInternetConnectivity()) {
                              await addJobAd();
                            }
                            if (!mounted) return;
                            Navigator.pop(context);
                          }
                        },
                        child: const Icon(
                          Icons.done,
                          color: Colors.white,
                          size: 28,
                        )),
                  ])))),
      Container(
        width: 52,
        height: 52,
        decoration: const BoxDecoration(
            color: Color.fromARGB(255, 49, 182, 209),
            borderRadius: BorderRadius.only(bottomRight: Radius.circular(50))),
        child: IconButton(
            alignment: Alignment.topLeft,
            iconSize: 28,
            onPressed: () => Navigator.pop(context),
            icon:
                const Icon(Icons.arrow_back_ios_rounded, color: Colors.white)),
      ),
    ])));
  }
}
