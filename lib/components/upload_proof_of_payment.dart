import 'dart:io';

import 'package:flutter/material.dart';

import '../constant.dart';

class UploadProofOfPayment extends StatelessWidget {
  const UploadProofOfPayment(
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
      child: Container(
        decoration: BoxDecoration(gradient: kPrimaryGradient),
        height: 400,
        width: 300,
        child: Stack(
          fit: StackFit.expand,
          clipBehavior: Clip.none,
          children: [
            Container(
              child: imageFile == null
                  ? (imageURL == "" || imageURL == null
                      ? Icon(
                          Icons.photo,
                          color: Colors.white,
                        )
                      : Image.network(imageURL, fit: BoxFit.fill))
                  : Image.file(imageFile, fit: BoxFit.fill),
            ),
            if (resetImage != null)
              Positioned(
                left: -3,
                bottom: 0,
                child: SizedBox(
                  height: 60,
                  width: 60,
                  child: TextButton(
                    style: ButtonStyle(
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
                right: -3,
                bottom: 0,
                child: SizedBox(
                  height: 60,
                  width: 60,
                  child: TextButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Color(0xFFF5F6F9)),
                    ),
                    onPressed: pickImage,
                    child: Icon(
                      Icons.add_a_photo,
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
