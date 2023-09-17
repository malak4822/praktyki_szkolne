import 'dart:io';
import 'package:flutter/material.dart';
import 'package:prakty/providers/edituser.dart';
import 'package:prakty/providers/googlesign.dart';
import 'package:provider/provider.dart';
import 'package:image/image.dart' as img;
import '../../main.dart';

class EditPhoto extends StatelessWidget {
  const EditPhoto({super.key});

  @override
  Widget build(BuildContext context) {
    var editFunction = Provider.of<EditUser>(context, listen: false);
    var user = Provider.of<GoogleSignInProvider>(context).getCurrentUser;

    File? imgFile = Provider.of<EditUser>(context, listen: true).imgFile;

    Future<File?> compressAndCropImage(File? imgFile) async {
      try {
        final bytes = imgFile!.readAsBytesSync();
        final image = img.decodeImage(bytes);

        final croppedImage = img.copyCrop(
          image!,
          x: (image.width - 2200) ~/ 2, // Center horizontally
          y: (image.height - 2200) ~/ 2, // Center vertically
          width: 2200, // Set width to 2200 pixels
          height: 2200, // Set height to 2200 pixels
        );

        final compressedImage = img.encodeJpg(croppedImage, quality: 20);

        final compressedCroppedImageFile = File(imgFile.path)
          ..writeAsBytesSync(compressedImage);

        return compressedCroppedImageFile;
      } catch (e) {
        print('Error compressing and cropping image: $e');
        return null;
      }
    }

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
        InkWell(
            onTap: () async => await editFunction.getImage(),
            child: SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 5,
                child: const Center(
                    child: Icon(Icons.add_a_photo_rounded,
                        color: Colors.white, size: 54))))
      ],
    );
  }
}