import 'dart:io';
import 'package:flutter/material.dart';
import 'package:prakty/providers/edituser.dart';
import 'package:prakty/providers/googlesign.dart';
import 'package:provider/provider.dart';
import '../../main.dart';

class EditPhoto extends StatelessWidget {
  const EditPhoto({super.key});

  @override
  Widget build(BuildContext context) {
    var editFunction = Provider.of<EditUser>(context, listen: false);
    var user = Provider.of<GoogleSignInProvider>(context).getCurrentUser;

    File? imgFile = Provider.of<EditUser>(context).imgFile;

    ImageProvider<Object> showCorrect(File? imgFile) {
      if (imgFile != null) {
        return FileImage(imgFile);
      } else if (user.profilePicture.isNotEmpty) {
        return NetworkImage(user.profilePicture);
      } else {
        return const AssetImage('images/man/man.png');
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
                image: showCorrect(imgFile),
                placeholder: const AssetImage('images/man/man.png'),
              )),
            )),
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
