import 'dart:io';

import 'package:flutter/material.dart';

import '../constant.dart';

class UploadImage extends StatelessWidget {
  const UploadImage(
      {Key key,
      this.imageFile,
      this.imageURL,
      this.resetImage,
      this.pickImage,
      this.height = 400,
      this.width = 300})
      : super(key: key);

  final File imageFile;
  final String imageURL;
  final Function resetImage;
  final Function pickImage;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        decoration: BoxDecoration(gradient: kPrimaryGradient),
        height: height,
        width: width,
        child: Stack(
          fit: StackFit.expand,
          clipBehavior: Clip.none,
          children: [
            InkWell(
              onTap: pickImage != null ? pickImage : null,
              child: Container(
                width: width,
                height: height,
                child: imageFile == null
                    ? (imageURL == "" || imageURL == null
                        ? Icon(
                            Icons.add_a_photo,
                            color: Colors.white,
                          )
                        : Image.network(imageURL, fit: BoxFit.fill))
                    : Image.file(imageFile, fit: BoxFit.fill),
              ),
            ),
            if (resetImage != null)
              Positioned(
                right: 0,
                bottom: 0,
                child: SizedBox(
                  height: 40,
                  width: 40,
                  child: TextButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.redAccent),
                    ),
                    onPressed: resetImage,
                    child: Column(
                      children: [
                        Icon(
                          imageURL != null ? Icons.refresh : Icons.delete,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
