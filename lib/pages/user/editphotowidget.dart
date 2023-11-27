import 'dart:io';
import 'package:flutter/material.dart';
import 'package:prakty/constants.dart';
import 'package:prakty/providers/edituser.dart';
import 'package:prakty/providers/googlesign.dart';
import 'package:provider/provider.dart';

class EditPhoto extends StatelessWidget {
  const EditPhoto({super.key});

  @override
  Widget build(BuildContext context) {
    var editFunction = Provider.of<EditUser>(context, listen: false);
    var user = Provider.of<GoogleSignInProvider>(context).getCurrentUser;

    File? imgFile = Provider.of<EditUser>(context).imgFile;

    ImageProvider<Object> showCorrect(File? imgFile, bool shouldReset) {
      if (imgFile != null) {
        return FileImage(imgFile);
      } else if (user.profilePicture.isNotEmpty) {
        // if (shouldReset) {
        //   return const NetworkImage(
        //       'https://firebasestorage.googleapis.com/v0/b/praktyki-szkolne.appspot.com/o/my_files%2Fman_praktyki.png?alt=media&token=dec782e2-1e50-4066-b0b6-0dc8019463d8&_gl=1*5iyx8e*_ga*MTg3NTU1MzM0MC4xNjk4MzAyMTM5*_ga_CW55HF8NVT*MTY5OTI4NjY4OC42LjEuMTY5OTI4NjcwMS40Ny4wLjA.');
        // } else {
        return NetworkImage(user.profilePicture);
        // }
      } else {
        return const NetworkImage(
            'https://firebasestorage.googleapis.com/v0/b/praktyki-szkolne.appspot.com/o/my_files%2Fman_praktyki.png?alt=media&token=dec782e2-1e50-4066-b0b6-0dc8019463d8&_gl=1*5iyx8e*_ga*MTg3NTU1MzM0MC4xNjk4MzAyMTM5*_ga_CW55HF8NVT*MTY5OTI4NjY4OC42LjEuMTY5OTI4NjcwMS40Ny4wLjA.');
      }
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Spacer(),
        CircleAvatar(
            radius: 125,
            backgroundColor: Colors.white,
            child: Container(
              height: 240,
              width: 240,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: gradient),
              ),
              child: ClipOval(
                  child: FadeInImage(
                fit: BoxFit.cover,
                image: showCorrect(imgFile, false),
                placeholder: const NetworkImage(
                    'https://firebasestorage.googleapis.com/v0/b/praktyki-szkolne.appspot.com/o/my_files%2Fman_praktyki.png?alt=media&token=dec782e2-1e50-4066-b0b6-0dc8019463d8&_gl=1*5iyx8e*_ga*MTg3NTU1MzM0MC4xNjk4MzAyMTM5*_ga_CW55HF8NVT*MTY5OTI4NjY4OC42LjEuMTY5OTI4NjcwMS40Ny4wLjA.'),
              )),
            )),
        // IconButton(
        //     onPressed: () {
        //       showCorrect(null, true);
        //     },
        //     icon: const Icon(Icons.delete, color: Colors.white),
        //     iconSize: 34),
        const Spacer(),
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          changePhoto(context, editFunction.getCameraImage, Icons.camera),
          changePhoto(context, editFunction.getStorageImage, Icons.photo),
        ])
      ],
    );
  }

  Widget changePhoto(context, Future<void> Function() function, icon) =>
      InkWell(
          onTap: () async {
            await function();
          },
          child: SizedBox(
              height: MediaQuery.of(context).size.height / 5,
              child: Center(child: Icon(icon, color: Colors.white, size: 54))));
}
