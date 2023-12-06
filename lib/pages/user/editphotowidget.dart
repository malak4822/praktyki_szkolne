import 'package:flutter/material.dart';
import 'package:prakty/constants.dart';
import 'package:prakty/models/user_model.dart';
import 'package:prakty/providers/edituser.dart';
import 'package:provider/provider.dart';

class EditPhoto extends StatefulWidget {
  const EditPhoto({super.key, required this.user});
  final MyUser user;
  @override
  State<EditPhoto> createState() => _EditPhotoState();
}

const String basicPPUrl =
    'https://firebasestorage.googleapis.com/v0/b/praktyki-szkolne.appspot.com/o/my_files%2Fman_praktyki.png?alt=media&token=dec782e2-1e50-4066-b0b6-0dc8019463d8&_gl=1*5iyx8e*_ga*MTg3NTU1MzM0MC4xNjk4MzAyMTM5*_ga_CW55HF8NVT*MTY5OTI4NjY4OC42LjEuMTY5OTI4NjcwMS40Ny4wLjA.';

class _EditPhotoState extends State<EditPhoto> {
  ImageProvider<Object> pictureToShow = const NetworkImage(basicPPUrl);

  void deleteImage() {
    Provider.of<EditUser>(context, listen: false).removeImage = basicPPUrl;
    setState(() {
      pictureToShow = const NetworkImage(basicPPUrl);
    });
  }

  void updatePhoto() {
    pictureToShow =
        FileImage(Provider.of<EditUser>(context, listen: false).imgFile);
  }

  @override
  void initState() {
    pictureToShow = widget.user.profilePicture.isNotEmpty
        ? NetworkImage(widget.user.profilePicture)
        : const NetworkImage(basicPPUrl);
    Provider.of<EditUser>(context, listen: false).setInitialFile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var editFunction = Provider.of<EditUser>(context, listen: false);

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
                image: pictureToShow,
                placeholder: const NetworkImage(basicPPUrl),
              )),
            )),
        IconButton(
            onPressed: () {
              deleteImage();
            },
            icon: const Icon(Icons.delete, color: Colors.white),
            iconSize: 34),
        const Spacer(),
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          changePhoto(editFunction, Icons.camera),
          changePhoto(editFunction, Icons.photo),
        ])
      ],
    );
  }

  Widget changePhoto(editFunction, icon) => InkWell(
      onTap: () async {
        if (icon == Icons.camera) {
          await editFunction.getCameraImage();
        } else {
          await editFunction.getStorageImage();
        }
        updatePhoto();
      },
      child: SizedBox(
          height: 140,
          child: Center(child: Icon(icon, color: Colors.white, size: 54))));
}
