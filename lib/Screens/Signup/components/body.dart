import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_event_customer/Screens/Signup/components/background.dart';
import 'package:go_event_customer/components/already_have_an_account_acheck.dart';
import 'package:go_event_customer/components/profile_pic.dart';
import 'package:go_event_customer/components/rounded_button.dart';
import 'package:go_event_customer/components/rounded_input_field.dart';
import 'package:go_event_customer/components/rounded_password_field.dart';
import 'package:go_event_customer/models/User.dart';
import 'package:go_event_customer/routes.dart';
import 'package:go_event_customer/services/auth_service.dart';
import 'package:go_event_customer/services/firebase_storage_service.dart';
import 'package:go_event_customer/services/firestore_service.dart';
import 'package:go_event_customer/services/image_picker_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../size_config.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  File imageFile;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _dobController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "SIGNUP",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: getProportionateScreenHeight(60),
              ),
              child: Column(
                children: [
                  ProfilePic(
                    imageFile: imageFile,
                    resetImage: () async {
                      imageFile = null;
                      setState(() {});
                    },
                    pickImage: () async {
                      final imagePicker = Provider.of<ImagePickerService>(
                          context,
                          listen: false);
                      File imagePicked = await imagePicker.pickImage(
                          source: ImageSource.gallery);
                      if (imagePicked != null) imageFile = imagePicked;
                      setState(() {});
                    },
                  ),
                  RoundedInputField(
                    hintText: "Vendor Name",
                    controller: _nameController,
                  ),
                  RoundedInputField(
                    hintText: "Email",
                    controller: _emailController,
                  ),
                  RoundedInputField(
                    hintText: "Phone Number",
                    icon: Icons.phone,
                    controller: _phoneNumberController,
                  ),
                  RoundedInputField(
                    hintText: "Address",
                    maxLines: 2,
                    icon: Icons.home,
                    controller: _addressController,
                  ),
                  RoundedInputField(
                    hintText: "City",
                    icon: Icons.location_city,
                    controller: _cityController,
                  ),
                  RoundedInputField(
                    hintText: "Date Of Birth",
                    icon: Icons.date_range,
                    controller: _dobController,
                  ),
                  RoundedInputField(
                    hintText: "Description",
                    maxLines: 4,
                    icon: Icons.description,
                    controller: _descriptionController,
                  ),
                  RoundedPasswordField(
                    controller: _passwordController,
                  ),
                  RoundedButton(
                      text: "SIGNUP",
                      press: () {
                        signUp();
                      }),
                ],
              ),
            ),
            AlreadyHaveAnAccountCheck(
              login: false,
              press: () {
                Navigator.of(context).pushNamed(Routes.login);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> signUp() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final displayName = _nameController.text.trim();
    final address = _addressController.text.trim();
    final dateOfBirth = _dobController.text.trim();
    final phoneNumber = _phoneNumberController.text.trim();
    final city = _cityController.text.trim();
    final description = _descriptionController.text.trim();
    try {
      //register User, get the UID and save the user data
      final auth = Provider.of<FirebaseAuthService>(context, listen: false);
      final registeredUser =
          await auth.registerWithEmailAndPassword(email, password);
      String downloadUrl = "";
      if (imageFile != null) {
        //upload image to storage
        final storage = FirebaseStorageService(uid: registeredUser.uid);
        downloadUrl = await storage.uploadProfilePicture(file: imageFile);
      }
      //save user data to firestore
      final userData = UserModel(
          uid: registeredUser.uid,
          displayName: displayName,
          phoneNumber: phoneNumber,
          address: address,
          city: city,
          description: description,
          dateOfBirth: dateOfBirth,
          role: "Customer",
          photoURL: downloadUrl);
      final database = FirestoreService(uid: registeredUser.uid);
      await database.setUserData(userData);
      await imageFile.delete();
    } catch (e) {
      print(e);
    }
  }
}
