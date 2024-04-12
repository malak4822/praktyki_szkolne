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
  @override
  void initState() {
    if (widget.user.profilePicture != null) {
      Provider.of<EditUser>(context, listen: false).setpictureToShow =
          widget.user.profilePicture;
      Provider.of<EditUser>(context, listen: false).initialFileSet();
    }
    super.initState();
  }

  @override
  void dispose() {
    if (context.mounted) {
      Provider.of<EditUser>(context, listen: false).deleteSelectedImage();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    EditUser editFunction = Provider.of<EditUser>(context, listen: false);

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
                  gradient: LinearGradient(colors: gradient)),
              child: SizedBox()
              // ClipOval(
              //     child: FadeInImage(
              //   fit: BoxFit.cover,
              //   image: Provider.of<EditUser>(context).pictureToShow ??
              //       const NetworkImage(basicPPUrl),
              //   placeholder: const NetworkImage(basicPPUrl),
              // )),
              
            )),
        IconButton(
            onPressed: () async {
              await Provider.of<EditUser>(context, listen: false)
                  .deleteSelectedImage();
              if (context.mounted) {
                Provider.of<EditUser>(context, listen: false).setpictureToShow =
                    null;
              }
            },
            icon: const Icon(Icons.delete_outline_rounded, color: Colors.white),
            iconSize: 34),
        const Spacer(),
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          changePhoto(editFunction, Icons.camera),
          changePhoto(editFunction, Icons.photo),
        ])
      ],
    );
  }

  Widget changePhoto(EditUser editFunction, icon) => InkWell(
      onTap: () async {
        if (icon == Icons.camera) {
          await editFunction.getCameraImage();
        } else {
          await editFunction.getStorageImage();
        }
      },
      child: SizedBox(
          height: 140,
          child: Center(child: Icon(icon, color: Colors.white, size: 54))));
}
