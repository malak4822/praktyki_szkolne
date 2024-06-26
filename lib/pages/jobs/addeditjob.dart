import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prakty/constants.dart';
import 'package:prakty/models/advertisements_model.dart';
import 'package:prakty/widgets/choselocation.dart';
import 'package:prakty/providers/edituser.dart';
import 'package:prakty/providers/googlesign.dart';
import 'package:prakty/services/database.dart';
import 'package:prakty/widgets/loadingscreen.dart';
import 'package:prakty/widgets/topbuttons.dart';
import 'package:prakty/widgets/inputwindows.dart';
import 'package:provider/provider.dart';

class AddEditJob extends StatefulWidget {
  const AddEditJob(
      {super.key, required this.isEditing, required this.initialEditingVal});
  final JobAdModel? initialEditingVal;
  final bool isEditing;
  @override
  State<AddEditJob> createState() => _AddEditJobState();
}

class _AddEditJobState extends State<AddEditJob> {
  JobAdModel? initialJobData;
  bool isNoticeOwner = false;
  bool showDeleteConfirmation = false;

  TextEditingController jobName = TextEditingController();
  TextEditingController companyName = TextEditingController();
  TextEditingController jobEmail = TextEditingController();
  TextEditingController jobPhone = TextEditingController();
  TextEditingController jobLocation = TextEditingController();
  late String jobPlaceId;
  TextEditingController jobQualification = TextEditingController();
  TextEditingController jobDescription = TextEditingController();
  bool canRemotely = false;
  bool arePaid = false;
  File? noticePhotoPath;
  bool isLocationFilled = false;
  final _formKey = GlobalKey<FormState>();

  bool isLoadingVis = false;

  Future<void> pickImg() async {
    final imagePicker = ImagePicker();

    final pickedImage = await imagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 18);
    if (pickedImage != null) {
      noticePhotoPath = File(pickedImage.path);

      setState(() {
        pictureToShow = FileImage(File(pickedImage.path));
      });
    }
  }

  ImageProvider<Object> pictureToShow =
      const AssetImage('images/photos/company_icon.png');
  @override
  void initState() {
    if (widget.isEditing == true) {
      if (widget.initialEditingVal!.jobImage != null) {
        pictureToShow = NetworkImage(widget.initialEditingVal!.jobImage!);

      }
      initialJobData = widget.initialEditingVal;
      jobName.text = initialJobData!.jobName;
      companyName.text = initialJobData!.companyName;
      jobEmail.text = initialJobData!.jobEmail;
      jobPhone.text = initialJobData!.jobPhone.toString();
      jobLocation.text = initialJobData!.jobLocation;
      jobPlaceId = initialJobData!.jobPlaceId;
      jobQualification.text = initialJobData!.jobQualification;
      jobDescription.text = initialJobData!.jobDescription;
      canRemotely = initialJobData!.canRemotely;
      arePaid = initialJobData!.arePaid;
      isNoticeOwner = true;
      super.initState();
    }
  }

  void showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: gradient[1],
          elevation: 8,
          titleTextStyle: fontSize16,
          title: const Text('Czy Na Pewno Chcesz Usunąć Ogłoszenie?',
              textAlign: TextAlign.center),
          actionsAlignment: MainAxisAlignment.spaceAround,
          actions: [
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              icon:
                  const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
              label: Text('Wróć', style: fontSize16),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                isLoadingVis = true;
                bool isOkay = await MyDb()
                    .deleteJobAdvert(widget.initialEditingVal!.jobId);
                isLoadingVis = false;
                if (isOkay) {
                  if (context.mounted) {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  }
                }
              },
              icon:
                  const Icon(Icons.delete_outline_rounded, color: Colors.white),
              label: Text('Usuń', style: fontSize16),
            ),
          ],
        );
      },
    );
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
                    Align(
                      child: Container(
                        width: 160,
                        height: 160,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Stack(
                            children: [
                              Image(
                                  width: 160,
                                  height: 160,
                                  fit: BoxFit.cover,
                                  image: pictureToShow),
                              imageButtons(() {
                                noticePhotoPath = null;
                                setState(() {
                                  pictureToShow = const AssetImage(
                                      'images/photos/company_icon.png');
                                });
                              }, Icons.delete_outline_rounded,
                                  Alignment.topLeft),
                              imageButtons(() async => await pickImg(),
                                  Icons.edit, Alignment.topRight),
                            ],
                          ),
                        ),
                      ),
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
                    updateValues(jobPhone, 'Telefon Kontaktowy', 1, 9,
                        Icons.phone, TextInputType.phone, null),
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
                                                    callBack:
                                                        (String locationText,
                                                            String placeRef) {
                                                  setState(() {
                                                    jobLocation.text =
                                                        locationText;
                                                  });
                                                  jobPlaceId = placeRef;
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
                    const SizedBox(height: 4),
                    Visibility(
                        visible: isLocationFilled,
                        child: const Row(
                          children: [
                            SizedBox(width: 52),
                            Text(
                              'Proszę Uzupełnić Miejsce',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 161, 42, 34),
                                  fontSize: 13),
                            )
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
                    CheckboxListTile(
                        contentPadding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 2 / 11),
                        checkboxShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        activeColor: Colors.white,
                        side: MaterialStateBorderSide.resolveWith((states) =>
                            const BorderSide(width: 2, color: Colors.white)),
                        title: Text("Praktyki Odpłatne", style: fontSize16),
                        value: arePaid,
                        dense: true,
                        controlAffinity: ListTileControlAffinity.leading,
                        onChanged: (newValue) {
                          setState(() {
                            arePaid = newValue!;
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
                                setState(() {
                                  isLoadingVis = true;
                                });
                                if (isNoticeOwner) {
                                  Map<bool, String?> isOkay = await MyDb()
                                      .updateJob(
                                          initialJobData!.jobId,
                                          noticePhotoPath,
                                          pictureToShow,
                                          jobName.text,
                                          companyName.text,
                                          jobEmail.text,
                                          int.parse(jobPhone.text),
                                          jobLocation.text,
                                          jobPlaceId,
                                          jobQualification.text,
                                          jobDescription.text,
                                          canRemotely,
                                          arePaid);
                                  if (isOkay.keys.first == true) {
                                    if (context.mounted) {
                                      Provider.of<GoogleSignInProvider>(context,
                                              listen: false)
                                          .refreshJobInfo(
                                              initialJobData!.jobId,
                                              isOkay.keys.first
                                                  ? isOkay.values.first
                                                  : null,
                                              jobName.text,
                                              companyName.text,
                                              jobEmail.text,
                                              int.parse(jobPhone.text),
                                              jobLocation.text,
                                              jobPlaceId,
                                              jobQualification.text,
                                              jobDescription.text,
                                              canRemotely,
                                              arePaid);
                                    }
                                  }
                                } else {
                                  if (context.mounted) {
                                    await MyDb().addFirestoreJobAd(
                                        Provider.of<GoogleSignInProvider>(
                                                context,
                                                listen: false)
                                            .getCurrentUser
                                            .userId,
                                        noticePhotoPath,
                                        jobName.text,
                                        companyName.text,
                                        jobEmail.text,
                                        int.parse(jobPhone.text),
                                        jobLocation.text,
                                        jobPlaceId,
                                        jobQualification.text,
                                        jobDescription.text,
                                        canRemotely,
                                        arePaid);
                                  }
                                }
                                setState(() {
                                  isLoadingVis = false;
                                });
                                if (context.mounted) {
                                  Navigator.pop(context);
                                }
                              }
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
      if (widget.isEditing)
        Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
                onTap: () => showDeleteConfirmationDialog(context),
                child: Container(
                    width: 62,
                    height: 62,
                    alignment: Alignment.topRight,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: gradient[1],
                        borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(62))),
                    child: const Icon(Icons.delete_outline_rounded,
                        color: Colors.white, size: 28)))),
      Visibility(visible: isLoadingVis, child: const LoadingWidget())
    ])));
  }

  Widget imageButtons(Function() function, IconData icon, Alignment align) =>
      Align(
          alignment: align,
          child: GestureDetector(
              onTap: function,
              child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                      color: Colors.black38,
                      borderRadius: (align == Alignment.topLeft)
                          ? const BorderRadius.only(
                              bottomRight: Radius.circular(16))
                          : const BorderRadius.only(
                              bottomLeft: Radius.circular(16)),
                      border: (align == Alignment.topLeft)
                          ? const Border(
                              right:
                                  BorderSide(width: 2.0, color: Colors.white),
                              bottom:
                                  BorderSide(width: 2.0, color: Colors.white),
                            )
                          : const Border(
                              left: BorderSide(width: 2.0, color: Colors.white),
                              bottom:
                                  BorderSide(width: 2.0, color: Colors.white),
                            )),
                  child: Icon(icon, size: 28, color: Colors.white))));

  @override
  void dispose() {
    jobName.dispose();
    jobEmail.dispose();
    jobPhone.dispose();
    jobLocation.dispose();
    jobDescription.dispose();
    companyName.dispose();
    jobQualification.dispose();
    super.dispose();
  }
}
