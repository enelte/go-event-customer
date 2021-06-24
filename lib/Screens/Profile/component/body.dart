import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_event_customer/components/display_name.dart';
import 'package:go_event_customer/components/main_background.dart';
import 'package:go_event_customer/components/profile_pic.dart';
import 'package:go_event_customer/components/rounded_button.dart';
import 'package:go_event_customer/components/rounded_input_field.dart';
import 'package:go_event_customer/models/UserData.dart';
import 'package:go_event_customer/services/auth_service.dart';
import 'package:go_event_customer/services/firebase_storage_service.dart';
import 'package:go_event_customer/services/firestore_service.dart';
import 'package:go_event_customer/services/image_picker_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class Body extends StatefulWidget {
  final UserDataModel userData;
  const Body({Key key, this.userData}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final _nameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _imageURL;
  File imageFile;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.userData.displayName;
    _phoneNumberController.text = widget.userData.phoneNumber;
    _addressController.text = widget.userData.address;
    _cityController.text = widget.userData.city;
    _descriptionController.text = widget.userData.description;
    _imageURL = widget.userData.photoURL;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneNumberController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseAuthService>(context).getCurrentUser();
    return MainBackground(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ProfilePic(
              imageFile: imageFile,
              imageURL: _imageURL,
              resetImage: () async {
                imageFile = null;
                setState(() {});
              },
              pickImage: () async {
                final imagePicker =
                    Provider.of<ImagePickerService>(context, listen: false);
                File imagePicked =
                    await imagePicker.pickImage(source: ImageSource.gallery);
                if (imagePicked != null) imageFile = imagePicked;
                setState(() {});
              },
            ),
            displayName(widget.userData.displayName, user.email,
                widget.userData.phoneNumber),
            SizedBox(height: 25),
            RoundedInputField(
              title: "Display Name",
              hintText: "Display Name",
              icon: Icons.person,
              controller: _nameController,
            ),
            RoundedInputField(
              title: "Phone Number",
              hintText: "Phone Number",
              icon: Icons.phone_android,
              controller: _phoneNumberController,
            ),
            RoundedInputField(
              title: "Address",
              hintText: "Address",
              icon: Icons.home,
              controller: _addressController,
            ),
            RoundedInputField(
              title: "City",
              hintText: "City",
              icon: Icons.location_city,
              controller: _cityController,
            ),
            RoundedInputField(
              title: "Description",
              hintText: "Description",
              maxLines: 4,
              icon: Icons.description,
              controller: _descriptionController,
            ),
            SizedBox(height: 25),
            RoundedButton(
              text: "Save Changes",
              press: () {
                editUserData();
              },
            ),
            SizedBox(height: 25),
          ],
        ),
      ),
    );
  }

  Future<void> editUserData() async {
    try {
      String downloadUrl = "";
      if (imageFile != null) {
        //upload image to storage
        final storage =
            Provider.of<FirebaseStorageService>(context, listen: false);
        downloadUrl = await storage.uploadProfilePicture(file: imageFile);
      }
      final displayName = _nameController.text.trim();
      final phoneNumber = _phoneNumberController.text.trim();
      final address = _addressController.text.trim();
      final city = _addressController.text.trim();
      final description = _descriptionController.text.trim();

      //save user data to firestore
      final userData = UserDataModel(
          displayName: displayName,
          phoneNumber: phoneNumber,
          address: address,
          city: city,
          description: description,
          photoURL: _imageURL);
      if (downloadUrl != "") {
        userData.photoURL = downloadUrl;
      }
      final database = Provider.of<FirestoreService>(context, listen: false);
      await database.setUserData(userData);
      if (imageFile != null) await imageFile.delete();
    } catch (e) {
      print(e);
    }
  }
}
