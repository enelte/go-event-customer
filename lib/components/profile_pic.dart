import 'dart:io';

import 'package:flutter/material.dart';

import '../constant.dart';

class ProfilePic extends StatelessWidget {
  const ProfilePic(
      {Key key, this.imageFile, this.imageURL, this.resetImage, this.pickImage})
      : super(key: key);

  final File imageFile;
  final String imageURL;
  final Function resetImage;
  final Function pickImage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: SizedBox(
        height: 115,
        width: 115,
        child: Stack(
          fit: StackFit.expand,
          clipBehavior: Clip.none,
          children: [
            CircleAvatar(
              backgroundImage: imageFile == null
                  ? (imageURL == "" || imageURL == null
                      ? null
                      : NetworkImage(imageURL))
                  : FileImage(imageFile),
            ),
            if (resetImage != null)
              Positioned(
                left: -16,
                bottom: 0,
                child: SizedBox(
                  height: 46,
                  width: 46,
                  child: TextButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                          side: BorderSide(color: Colors.white),
                        ),
                      ),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Color(0xFFF5F6F9)),
                    ),
                    onPressed: resetImage,
                    child: Icon(
                      Icons.refresh,
                      color: kPrimaryColor,
                    ),
                  ),
                ),
              ),
            if (pickImage != null)
              Positioned(
                right: -16,
                bottom: 0,
                child: SizedBox(
                  height: 46,
                  width: 46,
                  child: TextButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                          side: BorderSide(color: Colors.white),
                        ),
                      ),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Color(0xFFF5F6F9)),
                    ),
                    onPressed: pickImage,
                    child: Icon(
                      Icons.camera_alt,
                      color: kPrimaryColor,
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
