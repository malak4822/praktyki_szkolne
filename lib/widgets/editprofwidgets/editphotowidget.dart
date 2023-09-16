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
    var editFunction = Provider.of<EditUser>(context);
    var user = Provider.of<GoogleSignInProvider>(context).getCurrentUser;

    File? imgFile = Provider.of<EditUser>(context, listen: true).imgFile;

    File? compressAndCropImage() {
      try {
        final bytes = imgFile!.readAsBytesSync();
        final image = img.decodeImage(bytes);

        if (image == null) {
          // Unable to decode the image.
          return null;
        }

        final croppedImage = img.copyCrop(
          image,
          x: (image.width - 1700 / 2).toInt(),
          y: (image.height - 1700) ~/ 2,
          width: 300.toInt(),
          height: 300.toInt(),
        );

        final compressedImage = img.encodeJpg(croppedImage, quality: 70);

        final compressedCroppedImageFile = File(imgFile.path)
          ..writeAsBytesSync(compressedImage);

        return compressedCroppedImageFile;
      } catch (e) {
        print('Error compressing and cropping image: $e');
        return null;
      }
    }

    ImageProvider<Object> showCorrect() {
      if (imgFile != null) {
        compressAndCropImage();
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
            radius: 105,
            backgroundColor: Colors.white,
            child: Container(
              height: 200,
              width: 200,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: gradient),
              ),
              child: ClipOval(
                  child: FadeInImage(
                fit: BoxFit.cover,
                height: 160,
                fadeInDuration: const Duration(milliseconds: 500),
                image: showCorrect(), // Use FileImage for a local file
                placeholder: const AssetImage('images/man/man.png'),
              )),
            )),
        const Spacer(),
        InkWell(
            onTap: () async {
              await editFunction.getImage();
              if (imgFile != null) {
                // imgFile = compressAndCropImage();
              }
            },
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
