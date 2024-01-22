import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prakty/constants.dart';
import 'package:prakty/models/advertisements_model.dart';
import 'package:prakty/pages/user/choselocation.dart';
import 'package:prakty/providers/edituser.dart';
import 'package:prakty/providers/googlesign.dart';
import 'package:prakty/services/database.dart';
import 'package:prakty/widgets/topbuttons.dart';
import 'package:prakty/widgets/inputwindows.dart';
import 'package:provider/provider.dart';

class AddEditJob extends StatefulWidget {
  const AddEditJob({super.key, required this.initialEditingVal});
  final JobAdModel? initialEditingVal;

  @override
  State<AddEditJob> createState() => _AddEditJobState();
}

class _AddEditJobState extends State<AddEditJob> {
  JobAdModel? initialJobData;
  bool isNoticeOwner = false;

  TextEditingController jobName = TextEditingController();
  TextEditingController companyName = TextEditingController();
  TextEditingController jobEmail = TextEditingController();
  TextEditingController jobPhone = TextEditingController();
  TextEditingController jobLocation = TextEditingController();
  TextEditingController jobQualification = TextEditingController();
  TextEditingController jobDescription = TextEditingController();
  bool canRemotely = false;
  File? noticePhoto;
  bool isLocationFilled = false;
  final _formKey = GlobalKey<FormState>();

  Future<void> pickImg() async {
    final imagePicker = ImagePicker();

    final pickedImage = await imagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 18);
    if (pickedImage != null) {
      setState(() {
        pictureToShow = FileImage(File(pickedImage.path));
      });
    }
  }

  ImageProvider<Object> pictureToShow = const NetworkImage(
      'https://firebasestorage.googleapis.com/v0/b/praktyki-szkolne.appspot.com/o/my_files%2Fcompany_icon.png?alt=media&token=7c9796bf-2b8b-40d4-bc71-b85aeb82c269');

  @override
  void initState() {
    if (widget.initialEditingVal != null) {
      initialJobData = widget.initialEditingVal!;
      jobName.text = initialJobData!.jobName;
      companyName.text = initialJobData!.companyName;
      jobEmail.text = initialJobData!.jobEmail;
      jobPhone.text = initialJobData!.jobPhone.toString();
      jobLocation.text = initialJobData!.jobLocation;
      jobQualification.text = initialJobData!.jobQualification;
      jobDescription.text = initialJobData!.jobDescription;
      isNoticeOwner = true;
      if (noticePhoto != null) {
        pictureToShow = FileImage(noticePhoto!);
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print(isNoticeOwner
    //     ? initialJobData!.jobImage != null
    //         ? NetworkImage(initialJobData!.jobImage!)
    //         : FileImage(noticePhoto) as ImageProvider<Object>
    //     : noticePhoto != null
    //         ? FileImage(noticePhoto!)
    //         : const NetworkImage(
    //                 'https://clipart-library.com/new_gallery/1-15633_no-sign-png-no-symbol-white-png.png')
    //             as ImageProvider<Object>);
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
                    // if (isNoticeOwner)
                    Align(
                      child: Container(
                          width: 160,
                          height: 160,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: GestureDetector(
                              onTap: () async => await pickImg(),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Stack(children: [
                                    Image(
                                        width: 160,
                                        height: 160,
                                        fit: BoxFit.cover,
                                        image: pictureToShow),
                                    SizedBox.expand(
                                      child: Container(
                                        color: Colors.black45,
                                        child: const Center(
                                            child: Icon(Icons.edit,
                                                color: Colors.white, size: 46)),
                                      ),
                                    )
                                  ])))),
                    ),

                    const SizedBox(height: 24),
                    updateValues(jobName, 'Nazwa Stanowiska', 1, 28,
                        Icons.person, TextInputType.name, null),
                    const SizedBox(height: 12),
                    updateValues(companyName, 'Nazwa Firmy', 1, 24,
                        Icons.business, TextInputType.text, null),
                    const SizedBox(height: 12),
                    updateValues(jobQualification, 'Nazwa Kwalifikacji', 1, 28,
                        Icons.text_fields_rounded, TextInputType.text, null),
                    const SizedBox(height: 12),
                    updateValues(jobPhone, 'Numer Telefonu', 1, 9, Icons.phone,
                        TextInputType.phone, null),
                    const SizedBox(height: 12),
                    updateValues(jobEmail, 'Email', 1, null, Icons.email,
                        TextInputType.emailAddress, null),
                    const SizedBox(height: 22),
                    Row(
                      children: [
                        const Icon(Icons.location_on_sharp,
                            color: Colors.white),
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
                                            builder: (context) => FindOnMap(
                                                    callBack: (String val) {
                                                  setState(() {
                                                    jobLocation.text = val;
                                                  });
                                                })));
                                  },
                                  child: Center(
                                      child: Text(
                                    jobLocation.text.isEmpty
                                        ? 'Miejsce'
                                        : jobLocation.text,
                                    style: fontSize16,
                                    textAlign: TextAlign.center,
                                  ))),
                            ),
                          ),
                        )
                      ],
                    ),
                    Visibility(
                        visible: isLocationFilled,
                        child: Row(
                          children: [
                            const SizedBox(width: 52),
                            Text('Proszę Uzupełnić Miejsce', style: fontSize16)
                          ],
                        )),
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
                        title: Text("Praktyki Zdalne", style: fontSize16),
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
                            shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                    color: Colors.white, width: 2),
                                borderRadius: BorderRadius.circular(14)),
                            elevation: 16),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            if (jobLocation.text != '') {
                              setState(() {
                                isLocationFilled = false;
                              });

                              if (await Provider.of<EditUser>(context,
                                      listen: false)
                                  .checkInternetConnectivity()) {
                                if (isNoticeOwner) {
                                  bool isOkay = await MyDb().updateJob(
                                      initialJobData!.jobId,
                                      noticePhoto,
                                      jobName.text,
                                      companyName.text,
                                      jobEmail.text,
                                      int.parse(jobPhone.text),
                                      jobLocation.text,
                                      jobQualification.text,
                                      jobDescription.text,
                                      canRemotely);
                                  if (isOkay) {
                                    // widget.callBack(
                                    //     noticePhoto,
                                    //     jobName.text,
                                    //     companyName.text,
                                    //     jobEmail.text,
                                    //     int.parse(jobPhone.text),
                                    //     jobLocation.text,
                                    //     jobQualification.text,
                                    //     jobDescription.text,
                                    //     canRemotely);
                                  }
                                } else {
                                  if (!mounted) return;
                                  await MyDb().addFirestoreJobAd(
                                      Provider.of<GoogleSignInProvider>(context,
                                              listen: false)
                                          .getCurrentUser
                                          .userId,
                                      noticePhoto,
                                      jobName.text,
                                      companyName.text,
                                      jobEmail.text,
                                      int.parse(jobPhone.text),
                                      jobLocation.text,
                                      jobQualification.text,
                                      jobDescription.text,
                                      canRemotely);
                                }
                              }
                              if (!mounted) return;
                              Navigator.pop(context);
                            } else {
                              setState(() {
                                isLocationFilled = true;
                              });
                            }
                          }
                        },
                        child: const Icon(Icons.done_outline_rounded,
                            color: Colors.white, size: 24)),
                  ])))),
      backButton(context),
    ])));
  }
}
