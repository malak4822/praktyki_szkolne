import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prakty/main.dart';
import 'package:prakty/widgets/inputwindows.dart';

class AddJob extends StatefulWidget {
  AddJob({super.key});

  @override
  State<AddJob> createState() => _AddJobState();
}

class _AddJobState extends State<AddJob> {
  TextEditingController jobName = TextEditingController();

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
                    child: Stack(
                      children: [
                        Center(
                            child: ListView(
                                padding: const EdgeInsets.all(20),
                                children: [
                              if (noticePhoto != null)
                                GestureDetector(
                                    onTap: () async {
                                      await pickImg();
                                    },
                                    child: ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(80),
                                            bottomLeft: Radius.circular(20),
                                            bottomRight: Radius.circular(20),
                                            topRight: Radius.circular(20)),
                                        child: SizedBox(
                                          height: 250,
                                            child: Image(
                                          fit: BoxFit.cover,
                                          image: noticePhoto != null
                                              ? FileImage(noticePhoto!)
                                              : const NetworkImage(
                                                      'https://img.icons8.com/ios7/600w/000000/no-image.png')
                                                  as ImageProvider<Object>,
                                        )))),
                              // if (noticePhoto != null)
                              // const SizedBox(height: 15),
                              if (noticePhoto == null)
                                IconButton(
                                  iconSize: 42,
                                  icon: const Icon(
                                    Icons.photo,
                                    color: Colors.white,
                                  ),
                                  onPressed: () async {
                                    await pickImg();
                                  },
                                ),
                              const SizedBox(height: 15),
                              updateValues(jobName, 'Nazwa Stanowiska', 1, 30,
                                  Icons.person),
                              updateValues(jobName, 'Nazwa Stanowiska', 1, 30,
                                  Icons.person),
                              updateValues(jobName, 'Nazwa Stanowiska', 1, 30,
                                  Icons.person),
                              updateValues(jobName, 'Nazwa Stanowiska', 1, 30,
                                  Icons.person),
                            ])),
                        IconButton(
                            iconSize: 38,
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(
                              Icons.keyboard_backspace_rounded,
                              color: Colors.white,
                            ))
                      ],
                    )))));
  }
}
