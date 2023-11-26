import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prakty/constants.dart';
import 'package:prakty/pages/user/choselocation.dart';
import 'package:prakty/providers/edituser.dart';
import 'package:prakty/providers/googlesign.dart';
import 'package:prakty/services/database.dart';
import 'package:prakty/widgets/backbutton.dart';
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
                          icon: const Icon(Icons.photo, color: Colors.white),
                          onPressed: () async {
                            await pickImg();
                          }),
                    const SizedBox(height: 12),
                    updateValues(jobName, 'Nazwa Stanowiska', 1, 28,
                        Icons.person, TextInputType.name, null),
                    const SizedBox(height: 12),
                    updateValues(companyName, 'Nazwa Firmy', 1, 24,
                        Icons.business, TextInputType.text, null),
                    const SizedBox(height: 12),
                    updateValues(jobEmail, 'Email', 1, null,
                        Icons.email, TextInputType.emailAddress, null),
                    const SizedBox(height: 12),
                    updateValues(jobPhone, 'Telefon', 1, 9, Icons.phone,
                        TextInputType.phone, null),
                    const SizedBox(height: 12),
                    updateValues(jobQualification, 'Nazwa Kwalifikacji', 1, 28,
                        Icons.text_fields_rounded, TextInputType.text, null),
                    const SizedBox(height: 12),
                    updateValues(jobLocation, 'Miejsce', null, null,
                        Icons.location_on_rounded, null, () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  FindOnMap(callBack: (String val) {
                                    setState(() {
                                      jobLocation.text = val;
                                    });
                                  })));
                    }),
                    const SizedBox(height: 20),
                    updateValues(jobDescription, 'Opis Stanowiska', 10, 600,
                        Icons.description_outlined, TextInputType.text, null),
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
                            if (jobLocation.text != '') {
                              if (await Provider.of<EditUser>(context,
                                      listen: false)
                                  .checkInternetConnectivity()) {
                                if (!mounted) return;
                                List? eee = await MyDb().addFirestoreJobAd(
                                    Provider.of<GoogleSignInProvider>(context,
                                            listen: false)
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
                                if (eee != null) {
                             
                                  if (!mounted) return;
                                  Provider.of<GoogleSignInProvider>(context,
                                          listen: false)
                                      .refreshJobAd(eee);
                                }
                              }
                              if (!mounted) return;
                              Navigator.pop(context);
                            }
                          }
                        },
                        child: const Icon(
                          Icons.done,
                          color: Colors.white,
                          size: 28,
                        )),
                  ])))),
      backButton(context),
    ])));
  }
}
